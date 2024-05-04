Return-Path: <kvm-ppc+bounces-106-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFDB38BBDC1
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 20:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBE4A1C20C73
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 18:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CB874416;
	Sat,  4 May 2024 18:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E013vecf"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361791E51E
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714848289; cv=none; b=Of3Gb1deEL4KSLq4QLTDAep/pMqemO3xvabEN5q5iaiNnxzXqKEcEEptQsHUqAH69dqt/Vy9KlY0ugIslVGOfwVHdO8oK0tAs0Ysps/x0U/xSPZZTpV7aarizz8VavnDN89fiMSHXhQp7Ur1e4FFy2uUdMrmQ+Olzn7ItXw77sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714848289; c=relaxed/simple;
	bh=CUeuyv3Aedv9eHUC8fy1iiXz/9+shD+tl8oL0bajZx4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aRUS4+U2D8vXs7ErlT1ZpPjjPX17JhQKtyLfi2sF/tsdPfjrSu2lJjnRIX0I0Vl2KFHHRlFcN9Y6LjCtXaai6eGYc7mOxLNm4Ne06kznIFdgIykRm6IRGgC7CXUc8/d2boS+VqiWE5MrhkA+lz2Fxkgd2sWa8rB4pkOsNpa/X1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E013vecf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714848287; x=1746384287;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=CUeuyv3Aedv9eHUC8fy1iiXz/9+shD+tl8oL0bajZx4=;
  b=E013vecfHUm5T4+UrX+7EgnWsmY1Ia+6h8SPJ+zk9awC38zRmQ7iDPnd
   9CcrGwlsc0O5YgxNEZJmcsESTJCff+3bB6jMNo73U8Ll9UX26WxJEdxEY
   8xDFGtAwl6n3ybfw0jtFtbbOjdKGP+QseZ2SISjmOoK0+faGUjk+VNtto
   AxM1TGegcXmVWVJkkoElTUOaLGu0k3TzYb35/qBzkoGt5M2tlXDeeHVF/
   tf51STygRZ1eD1qzlVR8KX58//Z3jFrniwtZNGuT8KRkqEDzfWFZgds85
   wHO+zSq/yukvjeUfbQ/41vrgxVB2dkLHMRzhhpKyzboeh4QOp3J5wvbNI
   g==;
X-CSE-ConnectionGUID: 6uwpSkRDRcKMIJINhoE0RA==
X-CSE-MsgGUID: iupzXFXpRLyWdYY6igDlww==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="14424202"
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="14424202"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 11:44:46 -0700
X-CSE-ConnectionGUID: +CpTS6DcS22AINQx+30g5Q==
X-CSE-MsgGUID: JpRNSLNvTBCUF6eaUdi5pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="32560485"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 04 May 2024 11:44:44 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3KNG-000D4o-0w;
	Sat, 04 May 2024 18:44:42 +0000
Date: Sun, 5 May 2024 02:44:20 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 20/27] arch/arm64/kvm/mmu.c:1691:31:
 warning: format '%lx' expects argument of type 'long unsigned int', but
 argument 4 has type 'gfn_t' {aka 'long long unsigned int'}
Message-ID: <202405050218.bdbPXR1X-lkp@intel.com>
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
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20240505/202405050218.bdbPXR1X-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050218.bdbPXR1X-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050218.bdbPXR1X-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/arm64/kvm/mmu.c: In function 'kvm_handle_guest_abort':
>> arch/arm64/kvm/mmu.c:1691:31: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'gfn_t' {aka 'long long unsigned int'} [-Wformat=]
    1691 | trace_printk("XXX %s:%d gfn=%lx memslot=%lx hva=%lx write_fault=%d\n", __func__, __LINE__, gfn, memslot, hva, write_fault);
         |                             ~~^                                                            ~~~
         |                               |                                                            |
         |                               long unsigned int                                            gfn_t {aka long long unsigned int}
         |                             %llx
>> arch/arm64/kvm/mmu.c:1691:43: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'struct kvm_memory_slot *' [-Wformat=]
    1691 | trace_printk("XXX %s:%d gfn=%lx memslot=%lx hva=%lx write_fault=%d\n", __func__, __LINE__, gfn, memslot, hva, write_fault);
         |                                         ~~^                                                     ~~~~~~~
         |                                           |                                                     |
         |                                           long unsigned int                                     struct kvm_memory_slot *


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

