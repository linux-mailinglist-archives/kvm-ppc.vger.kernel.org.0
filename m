Return-Path: <kvm-ppc+bounces-113-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7418BBE2B
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 23:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 693911C20B83
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 21:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8432B6BB5D;
	Sat,  4 May 2024 21:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5h6K5A8"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6457C9A
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 21:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714857834; cv=none; b=S2Yw1Mu0kX4X7RL27EYwbVWjQKrl3FSqkw3SHdPF3KWQQWYfv+8qLqbRlU3HIN5vcC3frmxFOPX0b78R5E+dSEE/Zm/gSSMHhIaL5GO74pz1vec+U7JG3AFlQ/PPjoNl9oS8G/b5SF8R6mWPE+bzBMl9ZI5XF2shUIlSfeVgUak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714857834; c=relaxed/simple;
	bh=F6Q2FGeoLbXEOLD1Veo1SGH6gwFHH9X8kTza6lqzIMs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZU3A1uA4ZXvF4pQZirvYdV+wIX9gbGuS0763yMi9J+7VJFmlAT7MwrrE0dTs+y7MDKiSltT1lMNTB1VJqTup7TuJtmGWAtbUP44vnykc/c2NrqaTEiIxwKK5AvEoxnAYDSPrfofzSpsuq0xJZ1e7KHnAyM0wTbiLp/RLsrmbvCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5h6K5A8; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714857832; x=1746393832;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=F6Q2FGeoLbXEOLD1Veo1SGH6gwFHH9X8kTza6lqzIMs=;
  b=a5h6K5A8qt3K6DHqc4ZMVl/9R1XJI3SOlWDSb6qjHf4JZeS08wwHAYkG
   EULoILbEroHdn6nCf9VakEqv6Wf728ujRTsCgF5WA6zWRb7A7uZLul7on
   lyQvY3GgByySHDMIJziGXJuulQZkFNQrn9pAo6/i+Ium3z4i5vedpUsW2
   r044aEEt8RQXoyD12qwNoNbJKO3rpp1NPahzzQVCv7u/XU81cs6g0pBfa
   0y6lKObnazUKzZJdYVRCtb7PJ4ViFqBmfhGJg5S3kSHsbjjCcofd6THG3
   A9DnP1V6gvYu9xklZbrzUMiaXoVNb5kbGvWP7t1e9XJvAV3k1YdNo0CAj
   Q==;
X-CSE-ConnectionGUID: G+dS126hR8Wv96AqIEGtkA==
X-CSE-MsgGUID: SRauoOKfQtKC6/GCdg2Aww==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="14457058"
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="14457058"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 14:23:51 -0700
X-CSE-ConnectionGUID: IQJuEMHrS5WDpQdx9+jnwg==
X-CSE-MsgGUID: lGWBkUYAQJmp7jYEiQFrSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="32461765"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 04 May 2024 14:23:50 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3MrD-000DCM-12;
	Sat, 04 May 2024 21:23:47 +0000
Date: Sun, 5 May 2024 05:23:32 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 20/27] arch/arm64/kvm/mmu.c:1691:92:
 warning: format specifies type 'unsigned long' but the argument has type
 'gfn_t' (aka 'unsigned long long')
Message-ID: <202405050550.FRlmlKbI-lkp@intel.com>
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
commit: dc3f33bb180826ee0bcd0ecc79cad842ff3ffccf [20/27] XXX early kvmm implementation
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20240505/202405050550.FRlmlKbI-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 37ae4ad0eef338776c7e2cffb3896153d43dcd90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050550.FRlmlKbI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050550.FRlmlKbI-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arm64/kvm/mmu.c:7:
   In file included from include/linux/mman.h:5:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     509 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:515:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     516 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:527:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     528 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:536:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     537 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> arch/arm64/kvm/mmu.c:1691:92: warning: format specifies type 'unsigned long' but the argument has type 'gfn_t' (aka 'unsigned long long') [-Wformat]
    1691 | trace_printk("XXX %s:%d gfn=%lx memslot=%lx hva=%lx write_fault=%d\n", __func__, __LINE__, gfn, memslot, hva, write_fault);
         |                             ~~~                                                            ^~~
         |                             %llx
   include/linux/kernel.h:275:26: note: expanded from macro 'trace_printk'
     275 |                 do_trace_printk(fmt, ##__VA_ARGS__);    \
         |                                 ~~~    ^~~~~~~~~~~
   include/linux/kernel.h:286:37: note: expanded from macro 'do_trace_printk'
     286 |         __trace_printk_check_format(fmt, ##args);                       \
         |                                     ~~~    ^~~~
   include/linux/kernel.h:238:40: note: expanded from macro '__trace_printk_check_format'
     238 |                 ____trace_printk_check_format(fmt, ##args);             \
         |                                               ~~~    ^~~~
>> arch/arm64/kvm/mmu.c:1691:97: warning: format specifies type 'unsigned long' but the argument has type 'struct kvm_memory_slot *' [-Wformat]
    1691 | trace_printk("XXX %s:%d gfn=%lx memslot=%lx hva=%lx write_fault=%d\n", __func__, __LINE__, gfn, memslot, hva, write_fault);
         |                                         ~~~                                                     ^~~~~~~
   include/linux/kernel.h:275:26: note: expanded from macro 'trace_printk'
     275 |                 do_trace_printk(fmt, ##__VA_ARGS__);    \
         |                                 ~~~    ^~~~~~~~~~~
   include/linux/kernel.h:286:37: note: expanded from macro 'do_trace_printk'
     286 |         __trace_printk_check_format(fmt, ##args);                       \
         |                                     ~~~    ^~~~
   include/linux/kernel.h:238:40: note: expanded from macro '__trace_printk_check_format'
     238 |                 ____trace_printk_check_format(fmt, ##args);             \
         |                                               ~~~    ^~~~
>> arch/arm64/kvm/mmu.c:1691:92: warning: format specifies type 'unsigned long' but the argument has type 'gfn_t' (aka 'unsigned long long') [-Wformat]
    1691 | trace_printk("XXX %s:%d gfn=%lx memslot=%lx hva=%lx write_fault=%d\n", __func__, __LINE__, gfn, memslot, hva, write_fault);
         |                             ~~~                                                            ^~~
         |                             %llx
   include/linux/kernel.h:275:26: note: expanded from macro 'trace_printk'
     275 |                 do_trace_printk(fmt, ##__VA_ARGS__);    \
         |                                 ~~~    ^~~~~~~~~~~
   include/linux/kernel.h:291:36: note: expanded from macro 'do_trace_printk'
     291 |                 __trace_printk(_THIS_IP_, fmt, ##args);                 \
         |                                           ~~~    ^~~~
>> arch/arm64/kvm/mmu.c:1691:97: warning: format specifies type 'unsigned long' but the argument has type 'struct kvm_memory_slot *' [-Wformat]
    1691 | trace_printk("XXX %s:%d gfn=%lx memslot=%lx hva=%lx write_fault=%d\n", __func__, __LINE__, gfn, memslot, hva, write_fault);
         |                                         ~~~                                                     ^~~~~~~
   include/linux/kernel.h:275:26: note: expanded from macro 'trace_printk'
     275 |                 do_trace_printk(fmt, ##__VA_ARGS__);    \
         |                                 ~~~    ^~~~~~~~~~~
   include/linux/kernel.h:291:36: note: expanded from macro 'do_trace_printk'
     291 |                 __trace_printk(_THIS_IP_, fmt, ##args);                 \
         |                                           ~~~    ^~~~
   9 warnings generated.


vim +1691 arch/arm64/kvm/mmu.c

  1613	
  1614	/**
  1615	 * kvm_handle_guest_abort - handles all 2nd stage aborts
  1616	 * @vcpu:	the VCPU pointer
  1617	 *
  1618	 * Any abort that gets to the host is almost guaranteed to be caused by a
  1619	 * missing second stage translation table entry, which can mean that either the
  1620	 * guest simply needs more memory and we must allocate an appropriate page or it
  1621	 * can mean that the guest tried to access I/O memory, which is emulated by user
  1622	 * space. The distinction is based on the IPA causing the fault and whether this
  1623	 * memory region has been registered as standard RAM by user space.
  1624	 */
  1625	int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
  1626	{
  1627		unsigned long esr;
  1628		phys_addr_t fault_ipa;
  1629		struct kvm_memory_slot *memslot;
  1630		unsigned long hva;
  1631		bool is_iabt, write_fault, writable;
  1632		gfn_t gfn;
  1633		int ret, idx;
  1634	
  1635		esr = kvm_vcpu_get_esr(vcpu);
  1636	
  1637		fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
  1638		is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
  1639	
  1640		if (esr_fsc_is_permission_fault(esr)) {
  1641			/* Beyond sanitised PARange (which is the IPA limit) */
  1642			if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
  1643				kvm_inject_size_fault(vcpu);
  1644				return 1;
  1645			}
  1646	
  1647			/* Falls between the IPA range and the PARange? */
  1648			if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
  1649				fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
  1650	
  1651				if (is_iabt)
  1652					kvm_inject_pabt(vcpu, fault_ipa);
  1653				else
  1654					kvm_inject_dabt(vcpu, fault_ipa);
  1655				return 1;
  1656			}
  1657		}
  1658	
  1659		/* Synchronous External Abort? */
  1660		if (kvm_vcpu_abt_issea(vcpu)) {
  1661			/*
  1662			 * For RAS the host kernel may handle this abort.
  1663			 * There is no need to pass the error into the guest.
  1664			 */
  1665			if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_esr(vcpu)))
  1666				kvm_inject_vabt(vcpu);
  1667	
  1668			return 1;
  1669		}
  1670	
  1671		trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
  1672				      kvm_vcpu_get_hfar(vcpu), fault_ipa);
  1673	
  1674		/* Check the stage-2 fault is trans. fault or write fault */
  1675		if (!esr_fsc_is_translation_fault(esr) &&
  1676		    !esr_fsc_is_permission_fault(esr) &&
  1677		    !esr_fsc_is_access_flag_fault(esr)) {
  1678			kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
  1679				kvm_vcpu_trap_get_class(vcpu),
  1680				(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
  1681				(unsigned long)kvm_vcpu_get_esr(vcpu));
  1682			return -EFAULT;
  1683		}
  1684	
  1685		idx = srcu_read_lock(&vcpu->kvm->srcu);
  1686	
  1687		gfn = fault_ipa >> PAGE_SHIFT;
  1688		memslot = gfn_to_memslot(vcpu->kvm, gfn);
  1689		hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
  1690		write_fault = kvm_is_write_fault(vcpu);
> 1691	trace_printk("XXX %s:%d gfn=%lx memslot=%lx hva=%lx write_fault=%d\n", __func__, __LINE__, gfn, memslot, hva, write_fault);
  1692		if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
  1693			/*
  1694			 * The guest has put either its instructions or its page-tables
  1695			 * somewhere it shouldn't have. Userspace won't be able to do
  1696			 * anything about this (there's no syndrome for a start), so
  1697			 * re-inject the abort back into the guest.
  1698			 */
  1699			if (is_iabt) {
  1700				ret = -ENOEXEC;
  1701				goto out;
  1702			}
  1703	
  1704			if (kvm_vcpu_abt_iss1tw(vcpu)) {
  1705				kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
  1706				ret = 1;
  1707				goto out_unlock;
  1708			}
  1709	
  1710			/*
  1711			 * Check for a cache maintenance operation. Since we
  1712			 * ended-up here, we know it is outside of any memory
  1713			 * slot. But we can't find out if that is for a device,
  1714			 * or if the guest is just being stupid. The only thing
  1715			 * we know for sure is that this range cannot be cached.
  1716			 *
  1717			 * So let's assume that the guest is just being
  1718			 * cautious, and skip the instruction.
  1719			 */
  1720			if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
  1721				kvm_incr_pc(vcpu);
  1722				ret = 1;
  1723				goto out_unlock;
  1724			}
  1725	
  1726			/*
  1727			 * The IPA is reported as [MAX:12], so we need to
  1728			 * complement it with the bottom 12 bits from the
  1729			 * faulting VA. This is always 12 bits, irrespective
  1730			 * of the page size.
  1731			 */
  1732			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
  1733			ret = io_mem_abort(vcpu, fault_ipa);
  1734			goto out_unlock;
  1735		}
  1736	
  1737		/* Userspace should not be able to register out-of-bounds IPAs */
  1738		VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
  1739	
  1740		if (esr_fsc_is_access_flag_fault(esr)) {
  1741			handle_access_fault(vcpu, fault_ipa);
  1742			ret = 1;
  1743			goto out_unlock;
  1744		}
  1745	
  1746		ret = user_mem_abort(vcpu, fault_ipa, memslot, hva,
  1747				     esr_fsc_is_permission_fault(esr));
  1748		if (ret == 0)
  1749			ret = 1;
  1750	out:
  1751		if (ret == -ENOEXEC) {
  1752			kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
  1753			ret = 1;
  1754		}
  1755	out_unlock:
  1756		srcu_read_unlock(&vcpu->kvm->srcu, idx);
  1757		return ret;
  1758	}
  1759	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

