Return-Path: <kvm-ppc+bounces-114-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 443878BBE2D
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 23:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E80AB2101D
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 21:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC0156B79;
	Sat,  4 May 2024 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPHOrYtI"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7AF1EB5C
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 21:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714858433; cv=none; b=NvSdrYPQqGyd9tGqYAmm6UqL+dBa70OEe6Ox6VD01xEraC873WDzjCtnM1NvW2g4cs+6d9uWz3LwbYQzwzsC6qBISjCoNqQhkkbwKabYl3Z7wl7kagx3t22XyoCTGdoouQuj3WBbVd6LTSZ3MZE2lFHTXdncOOQMJC1Rt4HXaIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714858433; c=relaxed/simple;
	bh=VLa9TCFEiWRjUY9H51EtDHvkaaQHTqGpQdgqcmw2lJk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=A1xNZtQmBd3bQBFXBf0Ci8cg8HjR2zGB/oKh/aJBbrY7VdLyvp4zZ1QK7os5zUCbE+iYoEHC+NchA2uacJ6votcKy9IdOkRMloVpTwmMfvKrw28MpQEIi00fqlRHnAMx4Oe+G4vfNT9gc2cDqgOXlNeUl/WYK15omr5e7bEskuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPHOrYtI; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714858431; x=1746394431;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VLa9TCFEiWRjUY9H51EtDHvkaaQHTqGpQdgqcmw2lJk=;
  b=IPHOrYtIkXuhGPaRZKMR6vyM99UrsDCZnHZS6o67+2XAQXEAQXAWjUZD
   K6buf+JbKgQ3vp9AqJBSoJGfK5ge/aE5TtlMEGLCeAWYZNvJDSIVJDDt6
   C3cQe2RdpO0yBD/s2yR5zUqQN949NOPQ+o5J/N+KXhkCxNRspO4KWIuoe
   YYeQ0Ktnxi6fw8F8qmH3A3SjqA8L6brNiS3FwO84xAWGw/ek8t4x1u3e9
   ei8o/2E2eKeSCfku8kJGoi9Rk/Pa0ddZYA/PYFxy5gNmwjL8uENqBRy6y
   1esMnsxQod6opN170yCwEtYg+wyFKmunkcttpUZqTy5t/jMI3510TrkI3
   Q==;
X-CSE-ConnectionGUID: 2zX0XyCyR0m8PII9qjshpQ==
X-CSE-MsgGUID: B/L4g9YcT/2JEy9JYr+jow==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="10491959"
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="10491959"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 14:33:51 -0700
X-CSE-ConnectionGUID: eiTgQN+ATty+VOg8Dir75g==
X-CSE-MsgGUID: Sf/oCDtiQzmtutXLhPPBKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="32248767"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 04 May 2024 14:33:50 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3N0t-000DCy-2A;
	Sat, 04 May 2024 21:33:47 +0000
Date: Sun, 5 May 2024 05:33:45 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 24/27]
 arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6808:17: error:
 'KVM_ARCH_FLAG_VM_COUNTER_OFFSET' undeclared; did you mean
 'KVM_ARM_SET_COUNTER_OFFSET'?
Message-ID: <202405050557.AzQbDCw0-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/agraf/linux-2.6.git kvm-kho-gmem-test
head:   9a58862a298a63bad21d05191e28b857063bb9dc
commit: eac026594b9dc0e92a0093a3443b9bc973be99a4 [24/27] XXX WIP
config: powerpc-powernv_defconfig (https://download.01.org/0day-ci/archive/20240505/202405050557.AzQbDCw0-lkp@intel.com/config)
compiler: powerpc64le-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050557.AzQbDCw0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050557.AzQbDCw0-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/bug.h:5,
                    from arch/powerpc/include/asm/mmu.h:142,
                    from arch/powerpc/include/asm/paca.h:18,
                    from arch/powerpc/include/asm/current.h:13,
                    from include/linux/mutex.h:14,
                    from include/linux/kvm_types.h:23,
                    from include/kvm/iodev.h:6,
                    from arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:16:
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_kho_write_vcpu':
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4433:49: error: 'struct kvm_vcpu_arch' has no member named 'ctxt'
    4433 |                         .addr = __pa(&vcpu->arch.ctxt),
         |                                                 ^
   arch/powerpc/include/asm/bug.h:88:32: note: in definition of macro 'WARN_ON'
      88 |         int __ret_warn_on = !!(x);                              \
         |                                ^
   arch/powerpc/include/asm/page.h:217:9: note: in expansion of macro 'VIRTUAL_WARN_ON'
     217 |         VIRTUAL_WARN_ON((unsigned long)(x) < PAGE_OFFSET);              \
         |         ^~~~~~~~~~~~~~~
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4433:33: note: in expansion of macro '__pa'
    4433 |                         .addr = __pa(&vcpu->arch.ctxt),
         |                                 ^~~~
   In file included from arch/powerpc/include/asm/mmu.h:144:
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4433:49: error: 'struct kvm_vcpu_arch' has no member named 'ctxt'
    4433 |                         .addr = __pa(&vcpu->arch.ctxt),
         |                                                 ^
   arch/powerpc/include/asm/page.h:218:25: note: in definition of macro '__pa'
     218 |         (unsigned long)(x) & 0x0fffffffffffffffUL;                      \
         |                         ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4434:49: error: 'struct kvm_vcpu_arch' has no member named 'ctxt'
    4434 |                         .len = sizeof(vcpu->arch.ctxt),
         |                                                 ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_kho_write_vm':
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4477:55: error: 'struct kvm_arch' has no member named 'timer_data'
    4477 |         ret |= fdt_property(fdt, "voffset", &kvm->arch.timer_data.voffset, sizeof(u64));
         |                                                       ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4478:55: error: 'struct kvm_arch' has no member named 'timer_data'
    4478 |         ret |= fdt_property(fdt, "poffset", &kvm->arch.timer_data.poffset, sizeof(u64));
         |                                                       ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: At top level:
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4524:49: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    4524 | int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
         |                                                 ^~~~~~~~~~
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_unwrap_file':
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4552:58: error: 'struct kvm_arch' has no member named 'mmu'
    4552 |                 ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu, 0);
         |                                                          ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_wrap_vm':
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:4604:48: error: 'struct kvm_arch' has no member named 'mmu'
    4604 |         r = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu, 0);
         |                                                ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_kho_recover_vcpu':
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6750:27: error: 'struct kvm_vcpu_arch' has no member named 'ctxt'
    6750 |         memcpy(&vcpu->arch.ctxt, old_ctxt, sizeof(*old_ctxt));
         |                           ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6750:50: error: invalid application of 'sizeof' to incomplete type 'struct kvm_cpu_context'
    6750 |         memcpy(&vcpu->arch.ctxt, old_ctxt, sizeof(*old_ctxt));
         |                                                  ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_kho_recover_vm':
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6801:18: error: 'struct kvm_arch' has no member named 'timer_data'
    6801 |         kvm->arch.timer_data.poffset = *poffset;
         |                  ^
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6806:18: error: 'struct kvm_arch' has no member named 'timer_data'
    6806 |         kvm->arch.timer_data.voffset = *voffset;
         |                  ^
>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6808:17: error: 'KVM_ARCH_FLAG_VM_COUNTER_OFFSET' undeclared (first use in this function); did you mean 'KVM_ARM_SET_COUNTER_OFFSET'?
    6808 |         set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                 KVM_ARM_SET_COUNTER_OFFSET
   arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6808:17: note: each undeclared identifier is reported only once for each function it appears in
>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:6808:60: error: 'struct kvm_arch' has no member named 'flags'
    6808 |         set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
         |                                                            ^


vim +6808 arch/powerpc/kvm/../../../virt/kvm/kvm_main.c

  6765	
  6766	static int kvm_kho_recover_vm(const void *fdt, int node)
  6767	{
  6768		int ret = 0;
  6769		int vcpu_off;
  6770		struct kvm *kvm = NULL;
  6771		struct file *file;
  6772		const struct kvm_memory_slot *slots;
  6773		const u64 *voffset, *poffset;
  6774		const ulong *handle;
  6775		int nr_slots;
  6776		int l, i;
  6777	
  6778		if (fdt_node_check_compatible(fdt, node, "kvm,vm-v1"))
  6779			return -EINVAL;
  6780	
  6781		handle = fdt_getprop(fdt, node, "handle", &l);
  6782		if (!handle || l != sizeof(ulong))
  6783			return -EINVAL;
  6784	
  6785		// XXX On aarch64, the type defines IPA size. Needs to recover from original
  6786		ret = kvm_dev.fops->unlocked_ioctl(NULL, KVM_CREATE_VM, 0);
  6787		if (ret < 0)
  6788			return ret;
  6789	
  6790		file = fget_raw(ret);
  6791		kvm = file->private_data;
  6792	
  6793		ret = close_fd(ret);
  6794		if (ret)
  6795			return ret;
  6796	
  6797		/* TODO: Should go into arch code */
  6798		poffset = fdt_getprop(fdt, node, "poffset", &l);
  6799		if (!poffset)
  6800			return -EINVAL;
  6801		kvm->arch.timer_data.poffset = *poffset;
  6802	
  6803		voffset = fdt_getprop(fdt, node, "voffset", &l);
  6804		if (!voffset)
  6805			return -EINVAL;
  6806		kvm->arch.timer_data.voffset = *voffset;
  6807	
> 6808		set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
  6809	
  6810		/* Recover memslots */
  6811		slots = fdt_getprop(fdt, node, "slots", &l);
  6812		if (!slots)
  6813			return -EINVAL;
  6814	
  6815		nr_slots = l / sizeof(*slots);
  6816		for (i = 0; i < nr_slots; i++) {
  6817			const struct kvm_memory_slot *slot = &slots[i];
  6818			struct kvm_userspace_memory_region2 mem = {
  6819				.slot = slot->id,
  6820				.flags = slot->flags,
  6821				.guest_phys_addr = slot->base_gfn << PAGE_SHIFT,
  6822				.memory_size = slot->npages << PAGE_SHIFT,
  6823				.userspace_addr = slot->userspace_addr,
  6824				/* TODO: memfd */
  6825			};
  6826	
  6827			ret = kvm_set_memory_region(kvm, &mem);
  6828			if (ret)
  6829				return ret;
  6830		}
  6831	
  6832		/* Put it onto the fdbox dangling queue */
  6833		ret = fdbox_add_dangling(file, *handle);
  6834		if (ret)
  6835			return ret;
  6836	
  6837		fdt_for_each_subnode(vcpu_off, fdt, node) {
  6838			ret = kvm_kho_recover_vcpu(fdt, vcpu_off, kvm, file);
  6839			if (ret)
  6840				return ret;
  6841		}
  6842	
  6843		return ret;
  6844	}
  6845	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

