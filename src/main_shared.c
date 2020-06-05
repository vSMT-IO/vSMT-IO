#define _GNU_SOURCE
#define DEBUG_XPAIR_
#include <sys/signalfd.h>
#include <signal.h>
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>
#include <sched.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>
#include <assert.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <signal.h>
#include <sys/shm.h>
#include <sys/ipc.h>

#include "glib-2.0/glib.h"
#include "debug.h"

#define LEN						(1024UL)
#define PERIODIC_USLEEP			(1000UL)
#define VCPU_PATH			"/sys/fs/cgroup/cpuacct/machine"

#define handle_error_en(en, msg) \
		do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)
#define handle_error(msg) \
		do { perror(msg); exit(EXIT_FAILURE); } while (0)

struct vcpu {
	uint64_t num;
	uint64_t kvm_id;
	uint64_t cpu_id;
	uint64_t vcpu_id;
	uint64_t pid;
	uint64_t last_time_ns;
	uint64_t delta_ns;
	uint64_t pair_cpu_id;
	uint64_t pair_pid;
	uint64_t is_pair;
	uint64_t is_high;
	uint64_t is_scan;
	char kvm_name[LEN];
};

struct kvm {
	uint64_t id;
	uint64_t vcpu_num;
	char name[LEN];
};

//thresholds
static uint64_t periodic_usleep = (PERIODIC_USLEEP*1000UL/2UL);
//static uint64_t periodic_usleep = (PERIODIC_USLEEP*1000UL);

static uint64_t vm_num;
static uint64_t total_vcpu_num;
static struct kvm *kvm;
static struct vcpu *vcpu;
GList *vcpu_list;

int get_vcpu_count(void) {
	return get_nprocs();
}

uint64_t get_pid_affinity(int pid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = sched_getaffinity(pid, sizeof(cpu_set_t), &cpuset);
	if (s != 0) return -1;
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}

uint64_t get_affinity(void) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = pthread_getaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
	if (s != 0) return -1;
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}

uint64_t get_affinity_out(pthread_t tid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = pthread_getaffinity_np(tid, sizeof(cpu_set_t), &cpuset);
	if (s != 0) return -1;
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}

void set_pid_affinity(uint64_t vcpu_num, int pid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (sched_setaffinity(pid, sizeof(cpu_set_t), &cpuset) < 0) {
		fprintf(stderr, "Set task affinity error!\n");
	}
}

void set_affinity(uint64_t vcpu_num) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset) < 0) {
		fprintf(stderr, "Set thread to VCPU error!\n");
	}
}

void set_affinity_out(uint64_t vcpu_num, pthread_t tid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (pthread_setaffinity_np(tid, sizeof(cpu_set_t), &cpuset) < 0) {
		fprintf(stderr, "Set thread to VCPU error!\n");
	}
}

void set_priority(void) {
	struct sched_param param;
	int priority = sched_get_priority_max(SCHED_RR);
	param.sched_priority = priority;
	int s = pthread_setschedparam(pthread_self(), SCHED_RR, &param);
	if (s != 0) handle_error("Pthread_setschedparam error!\n");
}

void set_idle_priority(void) {
	struct sched_param param;
	param.sched_priority = 0;
	int s = pthread_setschedparam(pthread_self(), SCHED_IDLE, &param);
	if (s != 0) handle_error("Pthread_setschedparam error!\n");
}

void set_nice_priority(int priority, int pid) {
	int which = PRIO_PROCESS;

	int ret = setpriority(which, pid, priority);
}

uint64_t is_dir_exist(const gchar *dirpath) {
	if (TRUE == g_file_test(dirpath, G_FILE_TEST_IS_DIR))
		return 1;
	else
		return 0;
}

void debug_kvm(void) {
#if defined DEBUG_XPAIR_
	uint64_t i = 0;

		for (i = 1; i <= vm_num; i++) {
			g_message("This is kvm %lu: name is %s, vcpu num is %lu",
					kvm[i].id, kvm[i].name, kvm[i].vcpu_num);
		}
		g_message("Total vCPU number is %lu", total_vcpu_num);
#else
		return ;
#endif
}

void debug_vcpu(void) {
#if defined DEBUG_XPAIR_
	uint64_t i = 0;

	for (i = 0; i < total_vcpu_num; i++) {
		g_message("num: %lu, kvm_id %lu, vcpu_id %lu, cpu_id %lu, pid %lu, kvm_name %s, last_time_ns %lu, delta_ns %lu",
				vcpu[i].num, vcpu[i].kvm_id, vcpu[i].vcpu_id, vcpu[i].cpu_id,
				vcpu[i].pid, vcpu[i].kvm_name, vcpu[i].last_time_ns,
				vcpu[i].delta_ns);
	}
	printf("==================================================\n");
#else
	return ;
#endif
}

void debug_vcpu_list(void) {
#if defined DEBUG_XPAIR_
	uint64_t i = 0;
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		g_message("num: %lu, kvm_id %lu, vcpu_id %lu, cpu_id %lu, pid %lu, kvm_name %s, last_time_ns %lu, delta_ns %lu",
				tmp_vcpu->num, tmp_vcpu->kvm_id, tmp_vcpu->vcpu_id, tmp_vcpu->cpu_id,
				tmp_vcpu->pid, tmp_vcpu->kvm_name, tmp_vcpu->last_time_ns,
				tmp_vcpu->delta_ns);
	}
#endif
	printf("==================================================\n");
}

uint64_t is_file_exist(const gchar *filepath) {
	if (TRUE == g_file_test(filepath, G_FILE_TEST_EXISTS))
		return 1;
	else
		return 0;
}

void usage(void) {
	printf("Usage:\n\t./main config_file_path\n");
}

void parse_config(gchar *filepath) {
	GKeyFile *key_file;
	GError *error = NULL;
	int i = 0;
	char buf[LEN];

	memset(buf, '\0', LEN);
	key_file = g_key_file_new();
	if(!g_key_file_load_from_file(key_file, filepath,
				G_KEY_FILE_KEEP_COMMENTS | G_KEY_FILE_KEEP_TRANSLATIONS,
				&error)){
		g_debug("%s", error->message);
	} else {
		vm_num = g_key_file_get_uint64(key_file, "xPair",
				"vm_num", &error);
#if defined DEBUG_XPAIR_
		g_message("vm_num is %lu", vm_num);
#endif
		kvm = (struct kvm *) malloc(sizeof(struct kvm) * (vm_num + 1));
		if (kvm == NULL) {
			g_message("Malloc Error!");
			goto out;
		}
		for (i = 1; i <= vm_num; i++) {
			sprintf(buf, "vm%d", i);
			char *string = g_key_file_get_string(key_file, "xPair",
					buf, &error);
			memset(buf, '\0', LEN);
			sprintf(buf, "vm%d_vcpu_num", i);
			uint64_t vcpu_num = g_key_file_get_uint64(key_file, "xPair",
					buf, &error);
			memset(buf, '\0', LEN);
			kvm[i].id = i;
			kvm[i].vcpu_num = vcpu_num;
			total_vcpu_num += vcpu_num;
			memset(kvm[i].name, '\0', LEN);
			sprintf(kvm[i].name, "%s", string);
			memset(buf, '\0', LEN);
			sprintf(buf, "%s/%s.libvirt-qemu", VCPU_PATH, kvm[i].name);
			if (!is_dir_exist(buf)) {
				fprintf(stderr, "%s is not running, please check...", kvm[i].name);
				return ;
			}
		}
		//debug_kvm();
	}
out:
	if (key_file != NULL)
		g_key_file_free(key_file);
	return ;
}

void finalize_xpair(void) {
	if (NULL != kvm)
		free(kvm);
	if (NULL != vcpu)
		free(vcpu);
	if (NULL != vcpu_list)
		g_list_free(vcpu_list);
}

void sig_handler(int signo) {
	if (signo == SIGINT) {
		printf("Free resource ...\n");
		finalize_xpair();
		//free_resources();
	} else
		handle_error("Signal Error!\n");

	exit(EXIT_SUCCESS);
}

void init_xpair(void) {
	vm_num = 0;
	total_vcpu_num = 0;
	kvm = NULL;
	vcpu = NULL;
}

uint64_t read_uint64_t(char *filepath) {
	uint64_t data;

	FILE *fp = fopen(filepath, "r");
	fscanf(fp, "%lu", &data);
	fclose(fp);
	return data;
}

void read_vcpu_delta(void) {
	int i = 0;
	//int j = 0;
	char buf[LEN];
	uint64_t curr_time_ns = 0UL;

	memset(buf, '\0', LEN);
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		sprintf(buf, "%s/%s.libvirt-qemu/vcpu%lu/cpuacct.usage", VCPU_PATH, tmp_vcpu->kvm_name, tmp_vcpu->vcpu_id);
		curr_time_ns = read_uint64_t(buf);
		tmp_vcpu->delta_ns = curr_time_ns - tmp_vcpu->last_time_ns;
		tmp_vcpu->last_time_ns = curr_time_ns;
	}
}

void read_vcpu_usage(void) {
	int i = 0;
	//int j = 0;
	char buf[LEN];

	memset(buf, '\0', LEN);
#if 0
	for (i = 1; i <= vm_num; i++) {
		for (j = 0; j < kvm[i].vcpu_num; j++) {
			sprintf(buf, "%s/%s.libvirt-qemu/vcpu%lu/cpuacct.usage", VCPU_PATH, vcpu[j].kvm_name, vcpu[j].vcpu_id);
			vcpu[j].last_time_ns = read_uint64_t(buf);
		}
	}
#endif
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		sprintf(buf, "%s/%s.libvirt-qemu/vcpu%lu/cpuacct.usage", VCPU_PATH, tmp_vcpu->kvm_name, tmp_vcpu->vcpu_id);
		tmp_vcpu->last_time_ns = read_uint64_t(buf);
	}
}

void debug_list(void) {
#if defined DEBUG_XPAIR_
	int i = 0;

	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		g_message("i: %d, vcpu num: %lu", i, tmp_vcpu->num);
	}
#else
	return ;
#endif
}

void convert2list(void) {
	int i = 0;

	for (i = 0; i < total_vcpu_num; i++) {
		vcpu_list = g_list_append(vcpu_list, &(vcpu[i]));
	}
	//debug_list();
}

void init_vcpu(void) {
	int i = 0;
	int j = 0;
	uint64_t num = 0;
	char buf[LEN];

	memset(buf, '\0', LEN);
	vcpu = (struct vcpu *) malloc(sizeof(struct vcpu) * total_vcpu_num);
	if (NULL == vcpu) {
		handle_error("Malloc Error!");
	}
	for (i = 1; i <= vm_num; i++) {
		for (j = 0; j < kvm[i].vcpu_num; j++) {
			vcpu[num].num = num;
			vcpu[num].is_pair = 0;
			vcpu[num].is_scan = 0;
			vcpu[num].is_high = 0;
			vcpu[num].pair_cpu_id = 0;
			vcpu[num].pair_pid = 0;
			vcpu[num].kvm_id = kvm[i].id;
			vcpu[num].last_time_ns = 0UL;
			vcpu[num].delta_ns = 0UL;
			vcpu[num].vcpu_id = j;
			memset(vcpu[num].kvm_name, '\0', LEN);
			sprintf(vcpu[num].kvm_name, "%s", kvm[i].name);
			sprintf(buf, "%s/%s.libvirt-qemu/vcpu%lu/tasks", VCPU_PATH, vcpu[num].kvm_name, vcpu[num].vcpu_id);
			vcpu[num].pid = read_uint64_t(buf);
			memset(buf, '\0', LEN);
			vcpu[num].cpu_id = get_pid_affinity(vcpu[num].pid);
			num += 1;
		}
	}
	//debug_vcpu();
}

static gint compare_cpu_usage(gconstpointer vcpu_a, gconstpointer vcpu_b) {
	int ret = 0;

	struct vcpu *tmp_vcpu_a = (struct vcpu *) vcpu_a;
	struct vcpu *tmp_vcpu_b = (struct vcpu *) vcpu_b;

	//g_message("tmp_vcpu_a's num: %lu, delta_ns: %lu", tmp_vcpu_a->num, tmp_vcpu_a->delta_ns);
	//g_message("tmp_vcpu_b's num: %lu, delta_ns: %lu", tmp_vcpu_b->num, tmp_vcpu_b->delta_ns);

	if (tmp_vcpu_a->delta_ns < tmp_vcpu_b->delta_ns) ret = -1;
	else if (tmp_vcpu_a->delta_ns > tmp_vcpu_b->delta_ns) ret = 1;
	else ret = 0;

	return ret;
}

void sort_vcpu(void) {
	vcpu_list = g_list_sort(vcpu_list, compare_cpu_usage);
	return ;
}

int is_pair_beyond_threshold(uint64_t cpu_id) {
	int i = 0;
	//int ret = 0;
	uint64_t pair_cpu_id = 0;

	//FIXME: not general, specific to server 7 and server 8
	if (cpu_id < 24) pair_cpu_id = cpu_id + 24;
	else pair_cpu_id = cpu_id - 24;

	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		if (tmp_vcpu->cpu_id == pair_cpu_id) {
			if (tmp_vcpu->delta_ns > (PERIODIC_USLEEP/2)) return 1;
			else return 0;
		} else
			continue;
	}
}

void set_pair_flag(struct vcpu *pair_vcpu, int is_high) {
	int i = 0;
	//int ret = 0;
	uint64_t pair_cpu_id = 0;

	g_message("enter func %s", __func__);
	//FIXME: not general, specific to server 7 and server 8
	if (pair_vcpu->cpu_id < 24) pair_cpu_id = pair_vcpu->cpu_id + 24;
	else pair_cpu_id = pair_vcpu->cpu_id - 24;

	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		if (tmp_vcpu->cpu_id == pair_cpu_id) {
			pair_vcpu->pair_pid = tmp_vcpu->pid;
			pair_vcpu->pair_cpu_id = tmp_vcpu->cpu_id;
			pair_vcpu->is_scan = 1;
			tmp_vcpu->pair_pid = pair_vcpu->pid;
			tmp_vcpu->pair_cpu_id = pair_vcpu->cpu_id;
			tmp_vcpu->is_scan = 1;
			if (is_high) {
				if (tmp_vcpu->delta_ns > periodic_usleep) {
					pair_vcpu->is_pair = 1;
					tmp_vcpu->is_pair = 1;
				} else {
					pair_vcpu->is_pair = 0;
					tmp_vcpu->is_pair = 0;
				}
			} else {
				if (tmp_vcpu->delta_ns < periodic_usleep) {
					pair_vcpu->is_pair = 1;
					tmp_vcpu->is_pair = 1;
				} else {
					pair_vcpu->is_pair = 0;
					tmp_vcpu->is_pair = 0;
				}
			}
		} else
			continue;
	}
}

void set_vcpu_pair_flag(void) {
	int i = 0;
	int ret = 0;

	g_message("enter func %s", __func__);
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		if (tmp_vcpu->delta_ns <= periodic_usleep) {
			tmp_vcpu->is_high = 0;
			/*
			 * 1, check pair vCPU's CPU utilization.
			 * 2, find a high CPU utilization pair.
			 */
			if (tmp_vcpu->is_scan == 1) continue;
			set_pair_flag(tmp_vcpu, 0);
		} else {
			tmp_vcpu->is_high = 1;
			if (tmp_vcpu->is_scan == 1) continue;
			set_pair_flag(tmp_vcpu, 1);
		}
	}
}

//FIXME: use libvirt's standard APIs
void libvirt_set_affinity(struct vcpu *vcpu, struct vcpu *pair_vcpu) {
	char buf[LEN];

	memset(buf, '\0', LEN);
	sprintf(buf, "virsh vcpupin %s %lu %lu", vcpu->kvm_name, vcpu->vcpu_id, pair_vcpu->cpu_id);
	system(buf);

	memset(buf, '\0', LEN);
	sprintf(buf, "virsh vcpupin %s %lu %lu", pair_vcpu->kvm_name, pair_vcpu->vcpu_id, vcpu->cpu_id);
	system(buf);
}

void exchange(struct vcpu *vcpu, struct vcpu *pair_vcpu) {
	int i = 0;
	uint64_t tmp_cpu_id = 0;
	uint64_t tmp_pair_cpu_id = 0;
	uint64_t tmp_pair_pid = 0;

	g_message("enter func %s", __func__);
	set_pid_affinity(pair_vcpu->cpu_id, vcpu->pid);
	set_pid_affinity(vcpu->cpu_id, pair_vcpu->pid);
	//libvirt_set_affinity(vcpu, pair_vcpu);
	pair_vcpu->is_pair = 0;
	vcpu->is_pair = 0;
	tmp_cpu_id = vcpu->cpu_id;
	vcpu->cpu_id = pair_vcpu->cpu_id;
	pair_vcpu->cpu_id = tmp_cpu_id;

	tmp_pair_cpu_id = vcpu->pair_cpu_id;
	vcpu->pair_cpu_id = pair_vcpu->pair_cpu_id;
	pair_vcpu->pair_cpu_id = tmp_pair_cpu_id;

	tmp_pair_pid = vcpu->pair_pid;
	vcpu->pair_pid = pair_vcpu->pair_pid;
	pair_vcpu->pair_pid = tmp_pair_pid;
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		if (tmp_vcpu->cpu_id == vcpu->pair_cpu_id) {
			tmp_vcpu->is_pair = 0;
			tmp_vcpu->pair_cpu_id = vcpu->cpu_id;
			tmp_vcpu->pair_pid = vcpu->pid;
		} else if (tmp_vcpu->cpu_id == pair_vcpu->pair_cpu_id) {
			tmp_vcpu->is_pair = 0;
			tmp_vcpu->pair_cpu_id = pair_vcpu->cpu_id;
			tmp_vcpu->pair_pid = pair_vcpu->pid;
		} else {
			continue;
		}
	}
	return ;
}

int __do_xpair(struct vcpu *vcpu) {
	int i = 0;
	int ret = 1;

	g_message("enter func %s", __func__);
	for (i = g_list_length(vcpu_list) - 1; i >= 0; i--) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		if (tmp_vcpu->is_high == 0) {
			ret = 1;
			break;
		} else {
			if (tmp_vcpu->is_pair == 0) continue;
			else {
				exchange(vcpu, tmp_vcpu);
				ret = 0;
				break;
			}
		}
	}

	return ret;
}

void do_xpair(void) {
	int i = 0;
	int ret = 0;

	g_message("enter func %s", __func__);
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		if (tmp_vcpu->is_high == 1) return;
		else {
			if (tmp_vcpu->is_pair == 0) continue;
			else {
				ret = __do_xpair(tmp_vcpu);
				if (ret) return;
				else continue;
			}
		}
	}
}

void reset(void) {
	int i = 0;
	//int ret = 0;

	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		tmp_vcpu->is_high = 0;
		tmp_vcpu->is_pair = 0;
		tmp_vcpu->is_scan = 0;
	}
	return ;
}

void debug_pair(void) {
	int i = 0;
	int j = 0;
	int flag[48];

	for (i = 0; i < 48; i++) {
		flag[i] = 0;
	}

	printf("PCPU#\t\tKVM_NAME\t\tVCPU#\t\tCPU_USAGE_NS\n");
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		for (j = 0; j < g_list_length(vcpu_list); j++) {
			struct vcpu *pair_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, j);
			if (tmp_vcpu->pair_cpu_id == pair_vcpu->cpu_id &&
					flag[tmp_vcpu->cpu_id] == 0) {
				printf("%lu,%lu\t\t%s,%s\t\t%lu,%lu\t\t%lu,%lu\n",
						tmp_vcpu->cpu_id, pair_vcpu->cpu_id,
						tmp_vcpu->kvm_name, pair_vcpu->kvm_name,
						tmp_vcpu->vcpu_id, pair_vcpu->vcpu_id,
						tmp_vcpu->delta_ns, pair_vcpu->delta_ns);
				flag[tmp_vcpu->cpu_id] = 1;
				flag[pair_vcpu->cpu_id] = 1;
			}
		}
	}
}

void debug_flag(void) {
	int i = 0;
	int j = 0;
	int flag[48];

	for (i = 0; i < 48; i++) {
		flag[i] = 0;
	}

	printf("PCPU#\t\tKVM_NAME\t\tVCPU#\t\tIS_HIGH\t\tIS_PAIR\t\tIS_SCAN\n");
	for (i = 0; i < g_list_length(vcpu_list); i++) {
		struct vcpu *tmp_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, i);
		for (j = 0; j < g_list_length(vcpu_list); j++) {
			struct vcpu *pair_vcpu = (struct vcpu *) g_list_nth_data(vcpu_list, j);
			if (tmp_vcpu->pair_cpu_id == pair_vcpu->cpu_id && 
					flag[tmp_vcpu->cpu_id] == 0) {
				printf("%lu,%lu\t\t%s,%s\t\t%lu,%lu\t\t%lu,%lu\t\t%lu,%lu\t\t%lu,%lu\n",
						tmp_vcpu->cpu_id, pair_vcpu->cpu_id,
						tmp_vcpu->kvm_name, pair_vcpu->kvm_name,
						tmp_vcpu->vcpu_id, pair_vcpu->vcpu_id,
						tmp_vcpu->is_high, pair_vcpu->is_high,
						tmp_vcpu->is_pair, pair_vcpu->is_pair,
						tmp_vcpu->is_scan, pair_vcpu->is_scan);
				flag[tmp_vcpu->cpu_id] = 1;
				flag[pair_vcpu->cpu_id] = 1;
			}
		}
	}
}

void xpair(void) {
	set_vcpu_pair_flag();
	debug_flag();
	do_xpair();
	return ;
}


int main(int argc, char **argv) {
	if (argc != 2) {
		usage();
		exit(EXIT_FAILURE);
	}
	if (!is_file_exist(argv[1])) {
		usage();
		exit(EXIT_FAILURE);
	}
	if (signal(SIGINT, sig_handler) == SIG_ERR) {
		handle_error("SIGINT error!\n");
	}
	init_xpair();
	parse_config(argv[1]);
	init_vcpu();
	convert2list();
	
	read_vcpu_usage();
	//debug_vcpu_list();
	while (1) {
		usleep(PERIODIC_USLEEP);
		read_vcpu_delta();
		sort_vcpu();
		//debug_vcpu_list();
		xpair();
		debug_pair();
		reset();
	}

	finalize_xpair();
	return 0;
}
