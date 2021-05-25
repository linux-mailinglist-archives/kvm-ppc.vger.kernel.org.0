Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A490390BF2
	for <lists+kvm-ppc@lfdr.de>; Wed, 26 May 2021 00:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhEYWLB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 May 2021 18:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhEYWLB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 May 2021 18:11:01 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED1EC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 25 May 2021 15:09:28 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id v5so40153722ljg.12
        for <kvm-ppc@vger.kernel.org>; Tue, 25 May 2021 15:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zu4atpVfcEeRxsKH6Xmh4O5SM+I3rjn7K6w7Qfcp4FU=;
        b=Wf24gd/RtjVtLVP04vJH/51vC2HCQrqeAdZ+KH0Zr9KB3h1V58wkLo0QXktbvMnPLf
         0hKVqdS1sEO1Myle/7BnLqSuRjusn38C1pyQTArCWRj8kXygYYlhcwl2eu7/QYoopz3a
         27PZdTt8ZtiCDPHqJin7wCVYxdZbb/iOEQzH3pRVc/ClHPHLx5I6XYNA4jfjVF+fbGlf
         0FedhfTtgM3voBHtKzTnlvhfUhP5b6NMj1xNHah1FaPR/7Shm6Ci5ImHCDztLydigFTw
         dlBgEfsYWrA1txLEnBmkZLlx9UHrML8tHYX4gGyOFta2Z3bU8eUQQvXT3GKi9vVQHmQH
         9HIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zu4atpVfcEeRxsKH6Xmh4O5SM+I3rjn7K6w7Qfcp4FU=;
        b=tuqCkhRdwOD1FIwbTBdCDKE40UkWDusTvfbT8lKA7hfoXB9pNwlTja8xo+Py08jrPH
         RwgBoxazavfeHxRwwVY4zo26x+Nk/5k3a67dJtC6bPsX8S5G+F1vhW7WuThEE49xOj/C
         2l3LWyKM91XyIojFGgnp7gFeCbceb1VDTgS84jujmKol4KbpogkfF7Y2LSA1nMJ8/rjA
         9x7xR2TaKjFIIrxgHfLH/vx2BoAHbKQNKkcO5blolUsukP70hjzl7DxPfa9BOmzMIfja
         Fuzz2cAEnSIuD6VrhBd/2hMblntP0B+FiYu4AKPKhrwWq1tL8bt0K36dS3G3JonP1o0+
         5lBA==
X-Gm-Message-State: AOAM530eQiASgEyUJHoE/XwY5QQ6GQiuxj0lZOerx/QLeuPWuczGsjQy
        7c2ozmDVboOqLVC0hJFnOyPxgeaEzG4kFu1e/T3VYQ==
X-Google-Smtp-Source: ABdhPJw53+Euqn/MIRhed3HXAdIMUEKL1410gRd4mipuidR63HbpTSijx6DENLAC22s4NkxHKaUUm5o+iEqk50Mf5O8=
X-Received: by 2002:a2e:5d7:: with SMTP id 206mr23236435ljf.448.1621980567011;
 Tue, 25 May 2021 15:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210524151828.4113777-1-jingzhangos@google.com> <20210524151828.4113777-5-jingzhangos@google.com>
In-Reply-To: <20210524151828.4113777-5-jingzhangos@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 25 May 2021 15:09:00 -0700
Message-ID: <CALzav=eoZ6AAwZi2jh11zFmsGqL_tDCpvvntm=tV_u1rP1Hb=g@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] KVM: selftests: Add selftest for KVM statistics
 data binary interface
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 24, 2021 at 8:18 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Add selftest to check KVM stats descriptors validity.
>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   3 +
>  .../selftests/kvm/kvm_bin_form_stats.c        | 216 ++++++++++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
>  5 files changed, 235 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/kvm_bin_form_stats.c
>
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index bd83158e0e0b..35796667c944 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -43,3 +43,4 @@
>  /memslot_modification_stress_test
>  /set_memory_region_test
>  /steal_time
> +/kvm_bin_form_stats
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index e439d027939d..2984c86c848a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -76,6 +76,7 @@ TEST_GEN_PROGS_x86_64 += kvm_page_table_test
>  TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
>  TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
> +TEST_GEN_PROGS_x86_64 += kvm_bin_form_stats
>
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
> @@ -87,6 +88,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
>  TEST_GEN_PROGS_aarch64 += kvm_page_table_test
>  TEST_GEN_PROGS_aarch64 += set_memory_region_test
>  TEST_GEN_PROGS_aarch64 += steal_time
> +TEST_GEN_PROGS_aarch64 += kvm_bin_form_stats
>
>  TEST_GEN_PROGS_s390x = s390x/memop
>  TEST_GEN_PROGS_s390x += s390x/resets
> @@ -96,6 +98,7 @@ TEST_GEN_PROGS_s390x += dirty_log_test
>  TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
>  TEST_GEN_PROGS_s390x += kvm_page_table_test
>  TEST_GEN_PROGS_s390x += set_memory_region_test
> +TEST_GEN_PROGS_s390x += kvm_bin_form_stats
>
>  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
>  LIBKVM += $(LIBKVM_$(UNAME_M))
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a8f022794ce3..ee01a67022d9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -387,4 +387,7 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
>         __GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
>
> +int vm_get_statsfd(struct kvm_vm *vm);
> +int vcpu_get_statsfd(struct kvm_vm *vm, uint32_t vcpuid);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/kvm_bin_form_stats.c b/tools/testing/selftests/kvm/kvm_bin_form_stats.c
> new file mode 100644
> index 000000000000..09e12c5838af
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/kvm_bin_form_stats.c
> @@ -0,0 +1,216 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * kvm_bin_form_stats
> + *
> + * Copyright (C) 2021, Google LLC.
> + *
> + * Test the fd-based interface for KVM statistics.
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <errno.h>
> +
> +#include "test_util.h"
> +
> +#include "kvm_util.h"
> +#include "asm/kvm.h"
> +#include "linux/kvm.h"
> +
> +int stats_test(int stats_fd, int size_stat)
> +{
> +       ssize_t ret;
> +       int i;
> +       size_t size_desc, size_data = 0;
> +       struct kvm_stats_header header;
> +       struct kvm_stats_desc *stats_desc, *pdesc;
> +       void *stats_data;
> +
> +       /* Read kvm stats header */
> +       ret = read(stats_fd, &header, sizeof(header));
> +       TEST_ASSERT(ret == sizeof(header), "Read stats header");
> +       size_desc = sizeof(*stats_desc) + header.name_size;
> +
> +       /* Check id string in header, that should start with "kvm" */
> +       TEST_ASSERT(!strncmp(header.id, "kvm", 3) &&
> +                       strlen(header.id) < KVM_STATS_ID_MAXLEN,
> +                       "Invalid KVM stats type");
> +
> +       /* Sanity check for other fields in header */
> +       if (header.count == 0)
> +               return 0;
> +       /* Check overlap */
> +       TEST_ASSERT(header.desc_offset > 0 && header.data_offset > 0
> +                       && header.desc_offset >= sizeof(header)
> +                       && header.data_offset >= sizeof(header),
> +                       "Invalid offset fields in header");
> +       TEST_ASSERT(header.desc_offset > header.data_offset
> +                       || (header.desc_offset + size_desc * header.count <=
> +                               header.data_offset),
> +                       "Descriptor block is overlapped with data block");
> +
> +       /* Allocate memory for stats descriptors */
> +       stats_desc = calloc(header.count, size_desc);
> +       TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> +       /* Read kvm stats descriptors */
> +       ret = pread(stats_fd, stats_desc,
> +                       size_desc * header.count, header.desc_offset);
> +       TEST_ASSERT(ret == size_desc * header.count,
> +                       "Read KVM stats descriptors");
> +
> +       /* Sanity check for fields in descriptors */
> +       for (i = 0; i < header.count; ++i) {
> +               pdesc = (void *)stats_desc + i * size_desc;
> +               /* Check type,unit,base boundaries */
> +               TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
> +                               <= KVM_STATS_TYPE_MAX, "Unknown KVM stats type");
> +               TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK)
> +                               <= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
> +               TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK)
> +                               <= KVM_STATS_BASE_MAX, "Unknown KVM stats base");
> +               /* Check exponent for stats unit
> +                * Exponent for counter should be greater than or equal to 0
> +                * Exponent for unit bytes should be greater than or equal to 0
> +                * Exponent for unit seconds should be less than or equal to 0
> +                * Exponent for unit clock cycles should be greater than or
> +                * equal to 0
> +                */
> +               switch (pdesc->flags & KVM_STATS_UNIT_MASK) {
> +               case KVM_STATS_UNIT_NONE:
> +               case KVM_STATS_UNIT_BYTES:
> +               case KVM_STATS_UNIT_CYCLES:
> +                       TEST_ASSERT(pdesc->exponent >= 0,
> +                                       "Unsupported KVM stats unit");
> +                       break;
> +               case KVM_STATS_UNIT_SECONDS:
> +                       TEST_ASSERT(pdesc->exponent <= 0,
> +                                       "Unsupported KVM stats unit");
> +                       break;
> +               }
> +               /* Check name string */
> +               TEST_ASSERT(strlen(pdesc->name) < header.name_size,
> +                               "KVM stats name(%s) too long", pdesc->name);
> +               /* Check size field, which should not be zero */
> +               TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
> +                               pdesc->name);
> +               size_data += pdesc->size * size_stat;
> +       }
> +       /* Check overlap */
> +       TEST_ASSERT(header.data_offset >= header.desc_offset
> +                       || header.data_offset + size_data <= header.desc_offset,
> +                       "Data block is overlapped with Descriptor block");
> +       /* Check validity of all stats data size */
> +       TEST_ASSERT(size_data >= header.count * size_stat,
> +                       "Data size is not correct");
> +
> +       /* Allocate memory for stats data */
> +       stats_data = malloc(size_data);
> +       TEST_ASSERT(stats_data, "Allocate memory for stats data");
> +       /* Read kvm stats data as a bulk */
> +       ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> +       TEST_ASSERT(ret == size_data, "Read KVM stats data");
> +       /* Read kvm stats data one by one */
> +       size_data = 0;
> +       for (i = 0; i < header.count; ++i) {
> +               pdesc = (void *)stats_desc + i * size_desc;
> +               ret = pread(stats_fd, stats_data, pdesc->size * size_stat,
> +                               header.data_offset + size_data);
> +               TEST_ASSERT(ret == pdesc->size * size_stat,
> +                               "Read data of KVM stats: %s", pdesc->name);
> +               size_data += pdesc->size * size_stat;
> +       }
> +
> +       free(stats_data);
> +       free(stats_desc);
> +       return 0;
> +}
> +
> +
> +int vm_stats_test(struct kvm_vm *vm)
> +{
> +       int stats_fd;
> +       struct kvm_vm_stats_data *stats_data;
> +
> +       /* Get fd for VM stats */
> +       stats_fd = vm_get_statsfd(vm);
> +       TEST_ASSERT(stats_fd >= 0, "Get VM stats fd");
> +
> +       stats_test(stats_fd, sizeof(stats_data->value[0]));
> +       close(stats_fd);
> +
> +       return 0;
> +}
> +
> +int vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> +{
> +       int stats_fd;
> +       struct kvm_vcpu_stats_data *stats_data;
> +
> +       /* Get fd for VCPU stats */
> +       stats_fd = vcpu_get_statsfd(vm, vcpu_id);
> +       TEST_ASSERT(stats_fd >= 0, "Get VCPU stats fd");
> +
> +       stats_test(stats_fd, sizeof(stats_data->value[0]));
> +       close(stats_fd);
> +
> +       return 0;
> +}
> +
> +#define DEFAULT_NUM_VM         4
> +#define DEFAULT_NUM_VCPU       4
> +
> +/*
> + * Usage: kvm_bin_form_stats [#vm] [#vcpu]
> + * The first parameter #vm set the number of VMs being created.
> + * The second parameter #vcpu set the number of VCPUs being created.
> + * By default, DEFAULT_NUM_VM VM and DEFAULT_NUM_VCPU VCPU for the VM would be
> + * created for testing.
> + */
> +
> +int main(int argc, char *argv[])
> +{
> +       int max_vm = DEFAULT_NUM_VM, max_vcpu = DEFAULT_NUM_VCPU, ret, i, j;
> +       struct kvm_vm **vms;
> +
> +       /* Get the number of VMs and VCPUs that would be created for testing. */
> +       if (argc > 1) {
> +               max_vm = strtol(argv[1], NULL, 0);
> +               if (max_vm <= 0)
> +                       max_vm = DEFAULT_NUM_VM;
> +       }
> +       if (argc > 2) {
> +               max_vcpu = strtol(argv[2], NULL, 0);
> +               if (max_vcpu <= 0)
> +                       max_vcpu = DEFAULT_NUM_VCPU;
> +       }
> +
> +       /* Check the extension for binary stats */
> +       ret = kvm_check_cap(KVM_CAP_STATS_BINARY_FD);
> +       TEST_ASSERT(ret >= 0,
> +                       "Binary form statistics interface is not supported");
> +
> +       /* Create VMs and VCPUs */
> +       vms = malloc(sizeof(vms[0]) * max_vm);
> +       TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
> +       for (i = 0; i < max_vm; ++i) {
> +               vms[i] = vm_create(VM_MODE_DEFAULT,
> +                               DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +               for (j = 0; j < max_vcpu; ++j)
> +                       vm_vcpu_add(vms[i], j);
> +       }
> +
> +       /* Check stats read for every VM and VCPU */
> +       for (i = 0; i < max_vm; ++i) {
> +               vm_stats_test(vms[i]);
> +               for (j = 0; j < max_vcpu; ++j)
> +                       vcpu_stats_test(vms[i], j);
> +       }
> +
> +       for (i = 0; i < max_vm; ++i)
> +               kvm_vm_free(vms[i]);
> +       free(vms);
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fc83f6c5902d..d9e0b2c8b906 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2090,3 +2090,15 @@ unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
>         n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
>         return vm_adjust_num_guest_pages(mode, n);
>  }
> +
> +int vm_get_statsfd(struct kvm_vm *vm)
> +{
> +       return ioctl(vm->fd, KVM_STATS_GETFD, NULL);
> +}
> +
> +int vcpu_get_statsfd(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +       struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +       return ioctl(vcpu->fd, KVM_STATS_GETFD, NULL);
> +}
> --
> 2.31.1.818.g46aad6cb9e-goog
>
