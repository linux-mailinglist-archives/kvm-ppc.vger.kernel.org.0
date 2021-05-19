Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE576389904
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 May 2021 00:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbhESWBl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 May 2021 18:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhESWBi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 May 2021 18:01:38 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E35BC061760
        for <kvm-ppc@vger.kernel.org>; Wed, 19 May 2021 15:00:18 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so4296276pjb.2
        for <kvm-ppc@vger.kernel.org>; Wed, 19 May 2021 15:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fHdkF3fvolNOuFYwz6ESdopNclQTfwqdr+0wQQPe+sY=;
        b=BnC3sZNBw4v/c6aPf3jnVQ/9sWKoJpnWKVz8buEgWQkeNIEWVx56tnO+80KohVSNmx
         sVdFzzFCvTyur0BR+y7I/xMFUi2UGp6YoNFl0Ck7/rPjxfD1Ucnr3SSeMzzSYZnv9ey3
         5vUZ8AxhJeH5jb1FipuZo5VYXx/xyMe7SObrQ80WzR57HDPjkfENRqfRqtjv3lNlVcB6
         LRkTLBSjxGvtgZ/PXMWIj8bo8v65vASJOB2r4CxcwfPOq6GojQlginHqJC8vGiLfqsDB
         +qvhBj2yvZCgJwmCJ93xNtrbSlWTy45xXBw4DoyFkruDy/2o7+NLplqqLQtaplHhSCt5
         /KAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fHdkF3fvolNOuFYwz6ESdopNclQTfwqdr+0wQQPe+sY=;
        b=f3G1grHDLT3wLl673D6t8kqjiDGghjo8d0bUQ6COvhZ1rqWgPgWOmE/GPeIecP2BLV
         zq5wd+F+fWFJl0lIL3scFTrj+76YZVEHH3d2DTGjLaGbn8+k4pHjk2JrH5ktJtSYLNVT
         tbsS5iZo6D9D0eVRWpgrk4dw0noEzm1R644LXL0HFU3Xj4ZyP2lv5pficJO4Ny+XVb5j
         CsPTIpQXbI7RZrioWMNGJhU856JsKqyeawIC5UrhCo8sWorX+FfGAkH31i7qSXLlaWaV
         OulsxtGzE19Ig+5LJC4fCmnGHSOFKC1frM1ghrK75VQBzYFojg+FXMW6++tvmQoUZ2Zn
         v4fw==
X-Gm-Message-State: AOAM532C2cMPx+mQ4qaZMddbBabBlZtzZ2fl6fgjHIbe9XM9S0PpY/WR
        IMSZM4dq/p3aMCkn6z7i2AIVxw==
X-Google-Smtp-Source: ABdhPJx5qcRD/MIeqmgFi/W9uuc7aZJFj6EaB1Q1M39ddui7F144kxvLemyc1DkfY6bGF8jpNagyaw==
X-Received: by 2002:a17:902:c213:b029:f0:bbdf:3852 with SMTP id 19-20020a170902c213b02900f0bbdf3852mr1953006pll.56.1621461617480;
        Wed, 19 May 2021 15:00:17 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id a16sm294411pfa.95.2021.05.19.15.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 15:00:16 -0700 (PDT)
Date:   Wed, 19 May 2021 15:00:13 -0700
From:   Ricardo Koller <ricarkol@google.com>
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
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: Re: [PATCH v5 4/4] KVM: selftests: Add selftest for KVM statistics
 data binary interface
Message-ID: <YKWKbfXwVx0+G0OX@google.com>
References: <20210517145314.157626-1-jingzhangos@google.com>
 <20210517145314.157626-5-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517145314.157626-5-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 17, 2021 at 02:53:14PM +0000, Jing Zhang wrote:
> Add selftest to check KVM stats descriptors validity.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   3 +
>  .../selftests/kvm/kvm_bin_form_stats.c        | 379 ++++++++++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
>  5 files changed, 398 insertions(+)
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
>  	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
>  
> +int vm_get_statsfd(struct kvm_vm *vm);
> +int vcpu_get_statsfd(struct kvm_vm *vm, uint32_t vcpuid);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/kvm_bin_form_stats.c b/tools/testing/selftests/kvm/kvm_bin_form_stats.c
> new file mode 100644
> index 000000000000..dae44397d0f4
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/kvm_bin_form_stats.c
> @@ -0,0 +1,379 @@
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
> +int vm_stats_test(struct kvm_vm *vm)
> +{
> +	ssize_t ret;
> +	int i, stats_fd, err = -1;
> +	size_t size_desc, size_data = 0;
> +	struct kvm_stats_header header;
> +	struct kvm_stats_desc *stats_desc, *pdesc;
> +	struct kvm_vm_stats_data *stats_data;
> +
> +	/* Get fd for VM stats */
> +	stats_fd = vm_get_statsfd(vm);
> +	if (stats_fd < 0) {
> +		perror("Get VM stats fd");
> +		return err;
> +	}

It seems that the only difference between vm_stats_test and
vcpu_stats_test is what function to use for getting the fd.  If that's
the case, it might be better to move all the checks to a common
function.

> +	/* Read kvm vm stats header */
> +	ret = read(stats_fd, &header, sizeof(header));
> +	if (ret != sizeof(header)) {
> +		perror("Read VM stats header");
> +		goto out_close_fd;
> +	}
> +	size_desc = sizeof(*stats_desc) + header.name_size;
> +	/* Check id string in header, that should start with "kvm" */
> +	if (strncmp(header.id, "kvm", 3) ||
> +			strlen(header.id) >= KVM_STATS_ID_MAXLEN) {
> +		printf("Invalid KVM VM stats type!\n");
> +		goto out_close_fd;
> +	}
> +	/* Sanity check for other fields in header */
> +	if (header.count == 0) {
> +		err = 0;
> +		goto out_close_fd;
> +	}

As mentioned by David, it would be better to replace the checks with
TEST_ASSERT's. Most other selftests rely on TEST_ASSERT.

> +	/* Check overlap */
> +	if (header.desc_offset == 0 || header.data_offset == 0 ||
> +			header.desc_offset < sizeof(header) ||
> +			header.data_offset < sizeof(header)) {
> +		printf("Invalid offset fields in header!\n");
> +		goto out_close_fd;
> +	}
> +	if (header.desc_offset < header.data_offset &&
> +			(header.desc_offset + size_desc * header.count >
> +			header.data_offset)) {

Could you make the check more strict?

TEST_ASSERT(header.desc_offset + size_desc * header.count == header.data_offset,
	"The data block should be at the end of the descriptor block.");

> +		printf("VM Descriptor block is overlapped with data block!\n");
> +		goto out_close_fd;
> +	}
> +
> +	/* Allocate memory for stats descriptors */
> +	stats_desc = calloc(header.count, size_desc);
> +	if (!stats_desc) {
> +		perror("Allocate memory for VM stats descriptors");
> +		goto out_close_fd;
> +	}
> +	/* Read kvm vm stats descriptors */
> +	ret = pread(stats_fd, stats_desc,
> +			size_desc * header.count, header.desc_offset);

You could stress kvm_vm_stats_read() more by calling pread for more
offsets. For example, for every descriptor:

	pread(..., header.desc_offset + i * size_desc)

I realize that the typical usage will be to read once for all
descriptors. But kvm_vm_stats_read (and kvm_vcpu_stats_read) need to
handle any offset, and doing so seems to be quite complicated.

Actually, you could stress kvm_vm_stats_read() even more by calling it
for _every_ possible offset (and eventually invalid offsets and sizes).
One easier way to check this is by calling read all descriptors into
some reference buffer using a single pread, and then call it for all
offsets while comparing against the reference buf.

> +	if (ret != size_desc * header.count) {
> +		perror("Read KVM VM stats descriptors");
> +		goto out_free_desc;
> +	}
> +	/* Sanity check for fields in descriptors */
> +	for (i = 0; i < header.count; ++i) {
> +		pdesc = (void *)stats_desc + i * size_desc;

cast to (struct kvm_stats_desc *)

> +		/* Check type,unit,scale boundaries */
> +		if ((pdesc->flags & KVM_STATS_TYPE_MASK) > KVM_STATS_TYPE_MAX) {
> +			printf("Unknown KVM stats type!\n");
> +			goto out_free_desc;
> +		}
> +		if ((pdesc->flags & KVM_STATS_UNIT_MASK) > KVM_STATS_UNIT_MAX) {
> +			printf("Unknown KVM stats unit!\n");
> +			goto out_free_desc;
> +		}
> +		if ((pdesc->flags & KVM_STATS_SCALE_MASK) >
> +				KVM_STATS_SCALE_MAX) {
> +			printf("Unknown KVM stats scale!\n");
> +			goto out_free_desc;
> +		}
> +		/* Check exponent for stats unit
> +		 * Exponent for counter should be greater than or equal to 0
> +		 * Exponent for unit bytes should be greater than or equal to 0
> +		 * Exponent for unit seconds should be less than or equal to 0
> +		 * Exponent for unit clock cycles should be greater than or
> +		 * equal to 0
> +		 */
> +		switch (pdesc->flags & KVM_STATS_UNIT_MASK) {
> +		case KVM_STATS_UNIT_NONE:
> +		case KVM_STATS_UNIT_BYTES:
> +		case KVM_STATS_UNIT_CYCLES:
> +			if (pdesc->exponent < 0) {
> +				printf("Unsupported KVM stats unit!\n");
> +				goto out_free_desc;
> +			}
> +			break;
> +		case KVM_STATS_UNIT_SECONDS:
> +			if (pdesc->exponent > 0) {
> +				printf("Unsupported KVM stats unit!\n");
> +				goto out_free_desc;
> +			}
> +			break;

		default:
			TEST_FAIL("Unexpected unit ...");

> +		}
> +		/* Check name string */
> +		if (strlen(pdesc->name) >= header.name_size) {
> +			printf("KVM stats name(%s) too long!\n", pdesc->name);
> +			goto out_free_desc;
> +		}

Tighter check:

TEST_ASSERT(header.name_size > 0 &&
	strlen(pdesc->name) + 1 == header.name_size);

> +		/* Check size field, which should not be zero */
> +		if (pdesc->size == 0) {
> +			printf("KVM descriptor(%s) with size of 0!\n",
> +					pdesc->name);
> +			goto out_free_desc;
> +		}
> +		size_data += pdesc->size * sizeof(stats_data->value[0]);
> +	}
> +	/* Check overlap */
> +	if (header.data_offset < header.desc_offset &&
> +		header.data_offset + size_data > header.desc_offset) {
> +		printf("Data block is overlapped with Descriptor block!\n");
> +		goto out_free_desc;
> +	}

This won't be needed if you use the suggested TEST_ASSERT (the other
overlap check).

> +	/* Check validity of all stats data size */
> +	if (size_data < header.count * sizeof(stats_data->value[0])) {
> +		printf("Data size is not correct!\n");
> +		goto out_free_desc;
> +	}

Tighter check:

TEST_ASSERT(size_data == header.count * stats_data->value[0]);

> +
> +	/* Allocate memory for stats data */
> +	stats_data = malloc(size_data);
> +	if (!stats_data) {
> +		perror("Allocate memory for VM stats data");
> +		goto out_free_desc;
> +	}
> +	/* Read kvm vm stats data */
> +	ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> +	if (ret != size_data) {
> +		perror("Read KVM VM stats data");
> +		goto out_free_data;
> +	}
> +
> +	err = 0;
> +out_free_data:
> +	free(stats_data);
> +out_free_desc:
> +	free(stats_desc);
> +out_close_fd:
> +	close(stats_fd);
> +	return err;
> +}
> +
> +int vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> +{
> +	ssize_t ret;
> +	int i, stats_fd, err = -1;
> +	size_t size_desc, size_data = 0;
> +	struct kvm_stats_header header;
> +	struct kvm_stats_desc *stats_desc, *pdesc;
> +	struct kvm_vcpu_stats_data *stats_data;
> +
> +	/* Get fd for VCPU stats */
> +	stats_fd = vcpu_get_statsfd(vm, vcpu_id);
> +	if (stats_fd < 0) {
> +		perror("Get VCPU stats fd");
> +		return err;
> +	}
> +	/* Read kvm vcpu stats header */
> +	ret = read(stats_fd, &header, sizeof(header));
> +	if (ret != sizeof(header)) {
> +		perror("Read VCPU stats header");
> +		goto out_close_fd;
> +	}
> +	size_desc = sizeof(*stats_desc) + header.name_size;
> +	/* Check id string in header, that should start with "kvm" */
> +	if (strncmp(header.id, "kvm", 3) ||
> +			strlen(header.id) >= KVM_STATS_ID_MAXLEN) {
> +		printf("Invalid KVM VCPU stats type!\n");
> +		goto out_close_fd;
> +	}
> +	/* Sanity check for other fields in header */
> +	if (header.count == 0) {
> +		err = 0;
> +		goto out_close_fd;
> +	}
> +	/* Check overlap */
> +	if (header.desc_offset == 0 || header.data_offset == 0 ||
> +			header.desc_offset < sizeof(header) ||
> +			header.data_offset < sizeof(header)) {
> +		printf("Invalid offset fields in header!\n");
> +		goto out_close_fd;
> +	}
> +	if (header.desc_offset < header.data_offset &&
> +			(header.desc_offset + size_desc * header.count >
> +			header.data_offset)) {
> +		printf("VCPU Descriptor block is overlapped with data block!\n");
> +		goto out_close_fd;
> +	}

Same as above (tighter check).

> +
> +	/* Allocate memory for stats descriptors */
> +	stats_desc = calloc(header.count, size_desc);
> +	if (!stats_desc) {
> +		perror("Allocate memory for VCPU stats descriptors");
> +		goto out_close_fd;
> +	}
> +	/* Read kvm vcpu stats descriptors */
> +	ret = pread(stats_fd, stats_desc,
> +			size_desc * header.count, header.desc_offset);
> +	if (ret != size_desc * header.count) {
> +		perror("Read KVM VCPU stats descriptors");
> +		goto out_free_desc;
> +	}
> +	/* Sanity check for fields in descriptors */
> +	for (i = 0; i < header.count; ++i) {
> +		pdesc = (void *)stats_desc + i * size_desc;
> +		/* Check boundaries */
> +		if ((pdesc->flags & KVM_STATS_TYPE_MASK) > KVM_STATS_TYPE_MAX) {
> +			printf("Unknown KVM stats type!\n");
> +			goto out_free_desc;
> +		}
> +		if ((pdesc->flags & KVM_STATS_UNIT_MASK) > KVM_STATS_UNIT_MAX) {
> +			printf("Unknown KVM stats unit!\n");
> +			goto out_free_desc;
> +		}
> +		if ((pdesc->flags & KVM_STATS_SCALE_MASK) >
> +				KVM_STATS_SCALE_MAX) {
> +			printf("Unknown KVM stats scale!\n");
> +			goto out_free_desc;
> +		}
> +		/* Check exponent for stats unit
> +		 * Exponent for counter should be greater than or equal to 0
> +		 * Exponent for unit bytes should be greater than or equal to 0
> +		 * Exponent for unit seconds should be less than or equal to 0
> +		 * Exponent for unit clock cycles should be greater than or
> +		 * equal to 0
> +		 */
> +		switch (pdesc->flags & KVM_STATS_UNIT_MASK) {
> +		case KVM_STATS_UNIT_NONE:
> +		case KVM_STATS_UNIT_BYTES:
> +		case KVM_STATS_UNIT_CYCLES:
> +			if (pdesc->exponent < 0) {
> +				printf("Unsupported KVM stats unit!\n");
> +				goto out_free_desc;
> +			}
> +			break;
> +		case KVM_STATS_UNIT_SECONDS:
> +			if (pdesc->exponent > 0) {
> +				printf("Unsupported KVM stats unit!\n");
> +				goto out_free_desc;
> +			}
> +			break;
> +		}
> +		/* Check name string */
> +		if (strlen(pdesc->name) >= header.name_size) {
> +			printf("KVM stats name(%s) too long!\n", pdesc->name);
> +			goto out_free_desc;
> +		}
> +		/* Check size field, which should not be zero */
> +		if (pdesc->size == 0) {
> +			printf("KVM descriptor(%s) with size of 0!\n",
> +					pdesc->name);
> +			goto out_free_desc;
> +		}
> +		size_data += pdesc->size * sizeof(stats_data->value[0]);
> +	}
> +	/* Check overlap */
> +	if (header.data_offset < header.desc_offset &&
> +		header.data_offset + size_data > header.desc_offset) {
> +		printf("Data block is overlapped with Descriptor block!\n");
> +		goto out_free_desc;
> +	}
> +	/* Check validity of all stats data size */
> +	if (size_data < header.count * sizeof(stats_data->value[0])) {
> +		printf("Data size is not correct!\n");
> +		goto out_free_desc;
> +	}
> +
> +	/* Allocate memory for stats data */
> +	stats_data = malloc(size_data);
> +	if (!stats_data) {
> +		perror("Allocate memory for VCPU stats data");
> +		goto out_free_desc;
> +	}
> +	/* Read kvm vcpu stats data */
> +	ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> +	if (ret != size_data) {
> +		perror("Read KVM VCPU stats data");
> +		goto out_free_data;
> +	}
> +
> +	err = 0;
> +out_free_data:
> +	free(stats_data);
> +out_free_desc:
> +	free(stats_desc);
> +out_close_fd:
> +	close(stats_fd);
> +	return err;
> +}
> +
> +/*
> + * Usage: kvm_bin_form_stats [#vm] [#vcpu]
> + * The first parameter #vm set the number of VMs being created.
> + * The second parameter #vcpu set the number of VCPUs being created.
> + * By default, 1 VM and 1 VCPU for the VM would be created for testing.
> + */
> +
> +int main(int argc, char *argv[])
> +{
> +	int max_vm = 1, max_vcpu = 1, ret, i, j, err = -1;
> +	struct kvm_vm **vms;
> +
> +	/* Get the number of VMs and VCPUs that would be created for testing. */
> +	if (argc > 1) {
> +		max_vm = strtol(argv[1], NULL, 0);
> +		if (max_vm <= 0)
> +			max_vm = 1;
> +	}
> +	if (argc > 2) {
> +		max_vcpu = strtol(argv[2], NULL, 0);
> +		if (max_vcpu <= 0)
> +			max_vcpu = 1;
> +	}
> +
> +	/* Check the extension for binary stats */
> +	ret = kvm_check_cap(KVM_CAP_STATS_BINARY_FD);
> +	if (ret < 0) {
> +		printf("Binary form statistics interface is not supported!\n");
> +		return err;
> +	}
> +
> +	/* Create VMs and VCPUs */
> +	vms = malloc(sizeof(vms[0]) * max_vm);
> +	if (!vms) {
> +		perror("Allocate memory for storing VM pointers");
> +		return err;
> +	}
> +	for (i = 0; i < max_vm; ++i) {
> +		vms[i] = vm_create(VM_MODE_DEFAULT,
> +				DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +		for (j = 0; j < max_vcpu; ++j)
> +			vm_vcpu_add(vms[i], j);
> +	}
> +
> +	/* Check stats read for every VM and VCPU */
> +	for (i = 0; i < max_vm; ++i) {
> +		if (vm_stats_test(vms[i]))
> +			goto out_free_vm;
> +		for (j = 0; j < max_vcpu; ++j) {
> +			if (vcpu_stats_test(vms[i], j))
> +				goto out_free_vm;
> +		}
> +	}
> +
> +	err = 0;
> +out_free_vm:
> +	for (i = 0; i < max_vm; ++i)
> +		kvm_vm_free(vms[i]);
> +	free(vms);
> +	return err;
> +}
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fc83f6c5902d..d9e0b2c8b906 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2090,3 +2090,15 @@ unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
>  	n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
>  	return vm_adjust_num_guest_pages(mode, n);
>  }
> +
> +int vm_get_statsfd(struct kvm_vm *vm)
> +{
> +	return ioctl(vm->fd, KVM_STATS_GETFD, NULL);
> +}
> +
> +int vcpu_get_statsfd(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +	return ioctl(vcpu->fd, KVM_STATS_GETFD, NULL);
> +}
> -- 
> 2.31.1.751.gd2f1c929bd-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
