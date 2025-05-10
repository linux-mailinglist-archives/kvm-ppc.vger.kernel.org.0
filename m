Return-Path: <kvm-ppc+bounces-261-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 506FFAB240E
	for <lists+kvm-ppc@lfdr.de>; Sat, 10 May 2025 15:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAEA717D846
	for <lists+kvm-ppc@lfdr.de>; Sat, 10 May 2025 13:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE7B1E8356;
	Sat, 10 May 2025 13:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lmpk4wlK"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E61C28E8
	for <kvm-ppc@vger.kernel.org>; Sat, 10 May 2025 13:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746885564; cv=none; b=lnLVTiMy767Z4WMncRyUWxl/HTFnNajmjqERUO4A4/BjJiYvmKnDOMGsXihnvUHFzSbTe584Cs8fjjkanRiBARqWLuVAR+u+ePlm7udkM984FLgQMsytNoFfOy8uZr+sGK7RwokJ3eV6KINLgTdLrd6O2IWQR8LTXJr0gfgtIfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746885564; c=relaxed/simple;
	bh=lCaAI2cQ3dxuEfRcnaH+9DmU/OE4Xz25OdfT36yxlIU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RmHfgCBfOKTynjq8J5iOkO5pJmYOx1Zjch5fGBk5O4KteSzQv6oTKpdCjWrzgTFpWs5Fl2ga7yyzXp+4PmzhYFifsMMtrjA3vSE7r6fP4ipUzNT0/NGTlquzgCJHtgFg0iHXBCEWk4aSGGj5GuIVEuHLboZE0vxI9qLA9lpB77Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lmpk4wlK; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746885564; x=1778421564;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=lCaAI2cQ3dxuEfRcnaH+9DmU/OE4Xz25OdfT36yxlIU=;
  b=Lmpk4wlKQlzTtVywyHpbrKNBsnnQkPnWGDymKodlPJV+ojhNcknzpSFI
   SOhSt73evmN4r/HiPYwJwGlebZnI9gLeWKHe0oGwrpOsUE3joHsCAYpbB
   f19pfPfI+nWMRSEV+i6Rm3OHBr0gxCOk4T0RqsgTbY6JGYg39O3aL6Rk2
   F+ztDcAJO9qTFbgwZ1qjDqmgFiY2lCSAFgLgBiYGb4XZtumBUrM+2pHvB
   sMd7AytIVPWrxLVOyPfwl7ZQJ5c+DIJ22hEiF6wwttHYYKM2dQkj9eLnw
   ApHFIzNJ5WlUAwxsHwtsKzrI1IR0sN1VI66moGI9kF7Z1vk3QmzL6XjA7
   Q==;
X-CSE-ConnectionGUID: tJg18u8TRbudZn8CJhw8Vg==
X-CSE-MsgGUID: q9/fWLHzSfWpLSr8HP4ABQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11429"; a="59708175"
X-IronPort-AV: E=Sophos;i="6.15,278,1739865600"; 
   d="scan'208";a="59708175"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2025 06:59:23 -0700
X-CSE-ConnectionGUID: FO+VVi07S4OYzvqVrHVQig==
X-CSE-MsgGUID: czEDFO97SuqdJmJAHS0T8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,278,1739865600"; 
   d="scan'208";a="141802918"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 10 May 2025 06:59:21 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uDkjW-000D7h-1Y;
	Sat, 10 May 2025 13:59:18 +0000
Date: Sat, 10 May 2025 21:59:14 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kexec-cma 2/2] kernel/kexec_file.c:661:45: warning:
 format specifies type 'int' but the argument has type 'unsigned long'
Message-ID: <202505102142.kLGAquhf-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/agraf/linux-2.6.git kexec-cma
head:   752619bbe38c535612b1a9e5b47ea7d962c63449
commit: 752619bbe38c535612b1a9e5b47ea7d962c63449 [2/2] XXX
config: x86_64-buildonly-randconfig-001-20250510 (https://download.01.org/0day-ci/archive/20250510/202505102142.kLGAquhf-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250510/202505102142.kLGAquhf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505102142.kLGAquhf-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/kexec_file.c:661:45: warning: format specifies type 'int' but the argument has type 'unsigned long' [-Wformat]
     661 |         pr_warn("Allocated %d pages DMA memory\n", kbuf->memsz >> PAGE_SHIFT);
         |                            ~~                      ^~~~~~~~~~~~~~~~~~~~~~~~~
         |                            %lu
   include/linux/printk.h:560:37: note: expanded from macro 'pr_warn'
     560 |         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                                    ~~~     ^~~~~~~~~~~
   include/linux/printk.h:507:60: note: expanded from macro 'printk'
     507 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:479:19: note: expanded from macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning generated.


vim +661 kernel/kexec_file.c

   635	
   636	static int kexec_alloc_contig(struct kexec_buf *kbuf)
   637	{
   638		struct page *p;
   639		unsigned long mem;
   640		u32 i;
   641	
   642		p = dma_alloc_from_contiguous(NULL, kbuf->memsz >> PAGE_SHIFT,
   643					      get_order(kbuf->buf_align), true);
   644	
   645		if (!p)
   646			return -EADDRNOTAVAIL;
   647	
   648		/* Add the relevant pages to our dest_pages list so we find them later */
   649		for (i = 0; i < kbuf->memsz >> PAGE_SHIFT; i++)
   650			list_add(&p[i].lru, &kbuf->image->dest_pages);
   651	
   652		mem = page_to_boot_pfn(p) << PAGE_SHIFT;
   653	
   654		if (kimage_is_destination_range(kbuf->image, mem, mem + kbuf->memsz)) {
   655			/* Our region is already in use by a statically defined one. Bail out. */
   656			pr_warn("kexec: CMA overlaps existing mem: 0x%lx+0x%lx\n", mem, kbuf->memsz);
   657			return -EADDRNOTAVAIL;
   658		}
   659	
   660		kbuf->mem = page_to_boot_pfn(p) << PAGE_SHIFT;
 > 661		pr_warn("Allocated %d pages DMA memory\n", kbuf->memsz >> PAGE_SHIFT);
   662	
   663		return 0;
   664	}
   665	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

