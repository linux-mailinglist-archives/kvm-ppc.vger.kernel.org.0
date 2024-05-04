Return-Path: <kvm-ppc+bounces-104-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDB18BBDA8
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 20:33:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2F3E281D10
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 18:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999408289C;
	Sat,  4 May 2024 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BN02Czwx"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BAA17BDC
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 18:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714847627; cv=none; b=A97F8smYNqbxN9XGFYO/vsU0HII2/JKfg4TIJiwyc5PF45XmLjvBx9GFiYTb60/uec/cwBIJ8Ovt1Fxo3ssyozZia3Tg+96fOVANDui5+/Sn2xxVPzF8y6aX3AartbBq4mPcZ+XMuCoPELRb5WNYMpMNuIbV9XGmU+HYdEXq3rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714847627; c=relaxed/simple;
	bh=RoCfG4DA9AQpU8MFuJE6telorlbQmT/gsz6oF472bR0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HY/C8cwGbg/XCmS2MfWXtq3/sMNWtEYGYkGfUhIetYfAAXsU3T22qFLgrxH0Lu0/OlipeIDaIIPxywwP7O0QfheV0+xucFHESnA5XEqXsg4AfPfpA35wd/0tZgmOvebELK3/9RcDn7YTZ4+uSMCbxfPbzMAJrDOPkMMWvTIHj1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BN02Czwx; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714847626; x=1746383626;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=RoCfG4DA9AQpU8MFuJE6telorlbQmT/gsz6oF472bR0=;
  b=BN02Czwxnz4gOKC+XV5xXVhyF/PtQtGcb8s1DlcfBD0ntWLLEBt5fZaT
   9333Ly2EGIEzpWPGxnOCYyuH/P7aFYjuhQtO228HwKtD4uX5aD4m6ziLV
   zOG7rWUWyf7J440YxkXChIwFmXwMX9pMSyKvhb+BoTG1xh3VSfoB1EESS
   1pxqK88ZQy66YpIOzt5+mpN5SRVpeDjBMwL1J64p1F4ZXYmmnMAXYsWAI
   yBvjFwRD9Mtr/I+zEFWzdJ3aSfxwdCV1Gws848QTdD9uff+fFFyZPaZvJ
   u6Z95eGhQOQ28WkSv68HGIPDLi28yIVrgOgEDBt8g6vpNyDDKtbBkuHLr
   g==;
X-CSE-ConnectionGUID: FYe+PWr6SC+P/Xa/x+kFEQ==
X-CSE-MsgGUID: 45N76GIGQOeyD1QjVDqhBw==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="14445118"
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="14445118"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 11:33:45 -0700
X-CSE-ConnectionGUID: KWqNQYOsTGmw0EzcMRBF/A==
X-CSE-MsgGUID: uejx8RICScGNl1GyB5VRdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="58956808"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 04 May 2024 11:33:44 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3KCb-000D48-2r;
	Sat, 04 May 2024 18:33:41 +0000
Date: Sun, 5 May 2024 02:33:37 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 9/27] kernel/kexec_kho_out.c:208:26:
 warning: excess elements in struct initializer
Message-ID: <202405050241.50OPTPXf-lkp@intel.com>
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
commit: 55d4e99ed5b8909f348e838e03dda3cda4f2fa2e [9/27] x86: Add KHO support
config: i386-randconfig-053-20240505 (https://download.01.org/0day-ci/archive/20240505/202405050241.50OPTPXf-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050241.50OPTPXf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050241.50OPTPXf-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from kernel/kexec_kho_out.c:10:
   include/linux/kexec.h:369:34: error: field 'dt' has incomplete type
     369 |                 struct kexec_buf dt;
         |                                  ^~
   include/linux/kexec.h:370:34: error: field 'mem_cache' has incomplete type
     370 |                 struct kexec_buf mem_cache;
         |                                  ^~~~~~~~~
   kernel/kexec_kho_out.c: In function 'kho_mem_cache_add':
   kernel/kexec_kho_out.c:59:13: warning: variable 'prev_start' set but not used [-Wunused-but-set-variable]
      59 |         u64 prev_start = 0;
         |             ^~~~~~~~~~
   kernel/kexec_kho_out.c: In function 'kho_fill_kimage':
   kernel/kexec_kho_out.c:208:18: error: 'struct kexec_buf' has no member named 'image'
     208 |                 .image = image,
         |                  ^~~~~
>> kernel/kexec_kho_out.c:208:26: warning: excess elements in struct initializer
     208 |                 .image = image,
         |                          ^~~~~
   kernel/kexec_kho_out.c:208:26: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:209:18: error: 'struct kexec_buf' has no member named 'buffer'
     209 |                 .buffer = NULL,
         |                  ^~~~~~
   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from ./arch/x86/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:290,
                    from include/linux/build_bug.h:5,
                    from include/linux/init.h:5,
                    from include/linux/cma.h:5,
                    from kernel/kexec_kho_out.c:9:
   include/linux/stddef.h:8:14: warning: excess elements in struct initializer
       8 | #define NULL ((void *)0)
         |              ^
   kernel/kexec_kho_out.c:209:27: note: in expansion of macro 'NULL'
     209 |                 .buffer = NULL,
         |                           ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for '(anonymous)')
       8 | #define NULL ((void *)0)
         |              ^
   kernel/kexec_kho_out.c:209:27: note: in expansion of macro 'NULL'
     209 |                 .buffer = NULL,
         |                           ^~~~
   kernel/kexec_kho_out.c:210:18: error: 'struct kexec_buf' has no member named 'bufsz'
     210 |                 .bufsz = 0,
         |                  ^~~~~
   kernel/kexec_kho_out.c:210:26: warning: excess elements in struct initializer
     210 |                 .bufsz = 0,
         |                          ^
   kernel/kexec_kho_out.c:210:26: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:211:18: error: 'struct kexec_buf' has no member named 'mem'
     211 |                 .mem = KEXEC_BUF_MEM_UNKNOWN,
         |                  ^~~
   kernel/kexec_kho_out.c:211:24: error: 'KEXEC_BUF_MEM_UNKNOWN' undeclared (first use in this function)
     211 |                 .mem = KEXEC_BUF_MEM_UNKNOWN,
         |                        ^~~~~~~~~~~~~~~~~~~~~
   kernel/kexec_kho_out.c:211:24: note: each undeclared identifier is reported only once for each function it appears in
   kernel/kexec_kho_out.c:211:24: warning: excess elements in struct initializer
   kernel/kexec_kho_out.c:211:24: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:212:18: error: 'struct kexec_buf' has no member named 'memsz'
     212 |                 .memsz = 0,
         |                  ^~~~~
   kernel/kexec_kho_out.c:212:26: warning: excess elements in struct initializer
     212 |                 .memsz = 0,
         |                          ^
   kernel/kexec_kho_out.c:212:26: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:213:18: error: 'struct kexec_buf' has no member named 'buf_align'
     213 |                 .buf_align = SZ_64K, /* Makes it easier to map */
         |                  ^~~~~~~~~
   In file included from include/linux/mm.h:27,
                    from include/linux/pid_namespace.h:7,
                    from include/linux/ptrace.h:10,
                    from include/linux/elfcore.h:11,
                    from include/linux/vmcore_info.h:6,
                    from include/linux/kexec.h:18:
   include/linux/sizes.h:27:41: warning: excess elements in struct initializer
      27 | #define SZ_64K                          0x00010000
         |                                         ^~~~~~~~~~
   kernel/kexec_kho_out.c:213:30: note: in expansion of macro 'SZ_64K'
     213 |                 .buf_align = SZ_64K, /* Makes it easier to map */
         |                              ^~~~~~
   include/linux/sizes.h:27:41: note: (near initialization for '(anonymous)')
      27 | #define SZ_64K                          0x00010000
         |                                         ^~~~~~~~~~
   kernel/kexec_kho_out.c:213:30: note: in expansion of macro 'SZ_64K'
     213 |                 .buf_align = SZ_64K, /* Makes it easier to map */
         |                              ^~~~~~
   kernel/kexec_kho_out.c:214:18: error: 'struct kexec_buf' has no member named 'buf_max'
     214 |                 .buf_max = ULONG_MAX,
         |                  ^~~~~~~
   In file included from include/linux/limits.h:7,
                    from include/linux/overflow.h:6,
                    from include/linux/string.h:12,
                    from arch/x86/include/asm/page_32.h:18,
                    from arch/x86/include/asm/page.h:14,
                    from arch/x86/include/asm/user_32.h:5,
                    from arch/x86/include/asm/user.h:6,
                    from include/linux/user.h:1,
                    from include/linux/elfcore.h:5:
   include/vdso/limits.h:13:25: warning: excess elements in struct initializer
      13 | #define ULONG_MAX       (~0UL)
         |                         ^
   kernel/kexec_kho_out.c:214:28: note: in expansion of macro 'ULONG_MAX'
     214 |                 .buf_max = ULONG_MAX,
         |                            ^~~~~~~~~
   include/vdso/limits.h:13:25: note: (near initialization for '(anonymous)')
      13 | #define ULONG_MAX       (~0UL)
         |                         ^
   kernel/kexec_kho_out.c:214:28: note: in expansion of macro 'ULONG_MAX'
     214 |                 .buf_max = ULONG_MAX,
         |                            ^~~~~~~~~
   kernel/kexec_kho_out.c:215:18: error: 'struct kexec_buf' has no member named 'top_down'
     215 |                 .top_down = true,
         |                  ^~~~~~~~


vim +208 kernel/kexec_kho_out.c

4d945e93456555 Alexander Graf 2023-12-12  195  
4d945e93456555 Alexander Graf 2023-12-12  196  int kho_fill_kimage(struct kimage *image)
4d945e93456555 Alexander Graf 2023-12-12  197  {
4d945e93456555 Alexander Graf 2023-12-12  198  	int err = 0;
4d945e93456555 Alexander Graf 2023-12-12  199  	void *dt;
4d945e93456555 Alexander Graf 2023-12-12  200  
4d945e93456555 Alexander Graf 2023-12-12  201  	mutex_lock(&kho.lock);
4d945e93456555 Alexander Graf 2023-12-12  202  
4d945e93456555 Alexander Graf 2023-12-12  203  	if (!kho.active)
4d945e93456555 Alexander Graf 2023-12-12  204  		goto out;
4d945e93456555 Alexander Graf 2023-12-12  205  
4d945e93456555 Alexander Graf 2023-12-12  206  	/* Initialize kexec_buf for mem_cache */
4d945e93456555 Alexander Graf 2023-12-12  207  	image->kho.mem_cache = (struct kexec_buf) {
4d945e93456555 Alexander Graf 2023-12-12 @208  		.image = image,
4d945e93456555 Alexander Graf 2023-12-12  209  		.buffer = NULL,
4d945e93456555 Alexander Graf 2023-12-12  210  		.bufsz = 0,
4d945e93456555 Alexander Graf 2023-12-12  211  		.mem = KEXEC_BUF_MEM_UNKNOWN,
4d945e93456555 Alexander Graf 2023-12-12  212  		.memsz = 0,
4d945e93456555 Alexander Graf 2023-12-12  213  		.buf_align = SZ_64K, /* Makes it easier to map */
4d945e93456555 Alexander Graf 2023-12-12  214  		.buf_max = ULONG_MAX,
4d945e93456555 Alexander Graf 2023-12-12  215  		.top_down = true,
4d945e93456555 Alexander Graf 2023-12-12  216  	};
4d945e93456555 Alexander Graf 2023-12-12  217  
4d945e93456555 Alexander Graf 2023-12-12  218  	/*
4d945e93456555 Alexander Graf 2023-12-12  219  	 * We need to make all allocations visible here via the mem_cache so that
4d945e93456555 Alexander Graf 2023-12-12  220  	 * kho_is_destination_range() can identify overlapping regions and ensure
4d945e93456555 Alexander Graf 2023-12-12  221  	 * that no kimage (including the DT one) lands on handed over memory.
4d945e93456555 Alexander Graf 2023-12-12  222  	 *
4d945e93456555 Alexander Graf 2023-12-12  223  	 * Since we conveniently already built an array of all allocations, let's
4d945e93456555 Alexander Graf 2023-12-12  224  	 * pass that on to the target kernel so that reuse it to initialize its
4d945e93456555 Alexander Graf 2023-12-12  225  	 * memory blocks.
4d945e93456555 Alexander Graf 2023-12-12  226  	 */
4d945e93456555 Alexander Graf 2023-12-12  227  	err = kho_alloc_mem_cache(image, kho.dt);
4d945e93456555 Alexander Graf 2023-12-12  228  	if (err)
4d945e93456555 Alexander Graf 2023-12-12  229  		goto out;
4d945e93456555 Alexander Graf 2023-12-12  230  
4d945e93456555 Alexander Graf 2023-12-12  231  	err = kexec_add_buffer(&image->kho.mem_cache);
4d945e93456555 Alexander Graf 2023-12-12  232  	if (err)
4d945e93456555 Alexander Graf 2023-12-12  233  		goto out;
4d945e93456555 Alexander Graf 2023-12-12  234  
4d945e93456555 Alexander Graf 2023-12-12  235  	/*
4d945e93456555 Alexander Graf 2023-12-12  236  	 * Create a kexec copy of the DT here. We need this because lifetime may
4d945e93456555 Alexander Graf 2023-12-12  237  	 * be different between kho.dt and the kimage
4d945e93456555 Alexander Graf 2023-12-12  238  	 */
4d945e93456555 Alexander Graf 2023-12-12  239  	dt = kvmemdup(kho.dt, kho.dt_len, GFP_KERNEL);
4d945e93456555 Alexander Graf 2023-12-12  240  	if (!dt) {
4d945e93456555 Alexander Graf 2023-12-12  241  		err = -ENOMEM;
4d945e93456555 Alexander Graf 2023-12-12  242  		goto out;
4d945e93456555 Alexander Graf 2023-12-12  243  	}
4d945e93456555 Alexander Graf 2023-12-12  244  
4d945e93456555 Alexander Graf 2023-12-12  245  	/* Allocate target memory for kho dt */
4d945e93456555 Alexander Graf 2023-12-12  246  	image->kho.dt = (struct kexec_buf) {
4d945e93456555 Alexander Graf 2023-12-12  247  		.image = image,
4d945e93456555 Alexander Graf 2023-12-12  248  		.buffer = dt,
4d945e93456555 Alexander Graf 2023-12-12  249  		.bufsz = kho.dt_len,
4d945e93456555 Alexander Graf 2023-12-12  250  		.mem = KEXEC_BUF_MEM_UNKNOWN,
4d945e93456555 Alexander Graf 2023-12-12  251  		.memsz = kho.dt_len,
4d945e93456555 Alexander Graf 2023-12-12  252  		.buf_align = SZ_64K, /* Makes it easier to map */
4d945e93456555 Alexander Graf 2023-12-12  253  		.buf_max = ULONG_MAX,
4d945e93456555 Alexander Graf 2023-12-12  254  		.top_down = true,
4d945e93456555 Alexander Graf 2023-12-12  255  	};
4d945e93456555 Alexander Graf 2023-12-12  256  	err = kexec_add_buffer(&image->kho.dt);
4d945e93456555 Alexander Graf 2023-12-12  257  
4d945e93456555 Alexander Graf 2023-12-12  258  out:
4d945e93456555 Alexander Graf 2023-12-12  259  	mutex_unlock(&kho.lock);
4d945e93456555 Alexander Graf 2023-12-12  260  	return err;
4d945e93456555 Alexander Graf 2023-12-12  261  }
4d945e93456555 Alexander Graf 2023-12-12  262  

:::::: The code at line 208 was first introduced by commit
:::::: 4d945e934565554b4f997c57162e833303f56cb0 kexec: Add KHO support to kexec file loads

:::::: TO: Alexander Graf <graf@amazon.com>
:::::: CC: Alexander Graf <graf@amazon.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

