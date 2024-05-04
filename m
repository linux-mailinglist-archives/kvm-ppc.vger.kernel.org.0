Return-Path: <kvm-ppc+bounces-112-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 369878BBE23
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 23:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B35361F21897
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 21:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5D07FBCF;
	Sat,  4 May 2024 21:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GTamSdQr"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EC21DDEE
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714856574; cv=none; b=ek5KHQKKyo4niEIvONL//HjnUUI8TeYtUPmjwdDPRAobZvPbi1c+hgAoFU1lgD9qT48C5vy8LA+Z9TxN697o63zU9LEJQmariL4QVYARCg/1iS6RAAfO3IRL7jWP+Te1pHR6aGcmgj8YC3lygZ/IJbcsLgautydutvJM1ONmYnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714856574; c=relaxed/simple;
	bh=yeWhAjfubG81PVjv40/Al7yRkKv5OavDygWL+zqE9/M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Guwr6mLEFnaNAl5CSx0Xk4liKF5Gp3c37ngUEcbotpO4c3sjMIE2Nbx1UMc0dIiQ5+fOdbgfyILLGuCwm+gJBaExtn6xDz71gIQsRKtmlHKzG6l+niRrv+z8jyMux0a142cEzgQsvH5aEAijGKeNtNB8dJeSjkMuf/UbpXj6Xck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GTamSdQr; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714856571; x=1746392571;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=yeWhAjfubG81PVjv40/Al7yRkKv5OavDygWL+zqE9/M=;
  b=GTamSdQrIHtxGLu/7g7yxvpkqnARskHwgHYEbJgVLIv38aATs/fKnh4E
   M4I/WjIMZLH1ujTKmkKJ9jA+1ctBSW29QRG5xyThvbbuu8plykYgKPTKP
   nKTAVBzrp2hZUcEjIp0aK6RCq+LsjOtQxrE5+c6jxQ1akxZa69TvoxtOI
   HNZ9rexI1jvrNocPqnFs0XU+NKJRRe/BXPz/BlefZNqolveUUwkOgN9r1
   sEeTc9Cblt22q/On1pbwFSwdZsup3J2gywi0AK4CaMoReT62WxDp+7Wm0
   D14skmOSZvxZCdEVjmeI+8bfJL9uB2gDOmaE+IObaiU231nVBx8aYwAeR
   g==;
X-CSE-ConnectionGUID: UeovFYIjStK0w6UYO1yVcQ==
X-CSE-MsgGUID: v6ZHola8SWWhHOwEV624XQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="10487756"
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="10487756"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 14:02:51 -0700
X-CSE-ConnectionGUID: Tw1qJbUsQHix2SPHUVBJjQ==
X-CSE-MsgGUID: sUynLVNCS0atsi06837fUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="32245535"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 04 May 2024 14:02:49 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3MWs-000DBg-2u;
	Sat, 04 May 2024 21:02:46 +0000
Date: Sun, 5 May 2024 05:02:42 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 9/27] include/linux/kexec.h:369:34:
 error: field 'dt' has incomplete type
Message-ID: <202405050433.d3JlKXuK-lkp@intel.com>
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
config: i386-randconfig-053-20240505 (https://download.01.org/0day-ci/archive/20240505/202405050433.d3JlKXuK-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050433.d3JlKXuK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050433.d3JlKXuK-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from init/initramfs.c:576:
>> include/linux/kexec.h:369:34: error: field 'dt' has incomplete type
     369 |                 struct kexec_buf dt;
         |                                  ^~
>> include/linux/kexec.h:370:34: error: field 'mem_cache' has incomplete type
     370 |                 struct kexec_buf mem_cache;
         |                                  ^~~~~~~~~
--
   In file included from kernel/kexec_kho_out.c:10:
>> include/linux/kexec.h:369:34: error: field 'dt' has incomplete type
     369 |                 struct kexec_buf dt;
         |                                  ^~
>> include/linux/kexec.h:370:34: error: field 'mem_cache' has incomplete type
     370 |                 struct kexec_buf mem_cache;
         |                                  ^~~~~~~~~
   kernel/kexec_kho_out.c: In function 'kho_mem_cache_add':
   kernel/kexec_kho_out.c:59:13: warning: variable 'prev_start' set but not used [-Wunused-but-set-variable]
      59 |         u64 prev_start = 0;
         |             ^~~~~~~~~~
   kernel/kexec_kho_out.c: In function 'kho_fill_kimage':
>> kernel/kexec_kho_out.c:208:18: error: 'struct kexec_buf' has no member named 'image'
     208 |                 .image = image,
         |                  ^~~~~
   kernel/kexec_kho_out.c:208:26: warning: excess elements in struct initializer
     208 |                 .image = image,
         |                          ^~~~~
   kernel/kexec_kho_out.c:208:26: note: (near initialization for '(anonymous)')
>> kernel/kexec_kho_out.c:209:18: error: 'struct kexec_buf' has no member named 'buffer'
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
>> kernel/kexec_kho_out.c:210:18: error: 'struct kexec_buf' has no member named 'bufsz'
     210 |                 .bufsz = 0,
         |                  ^~~~~
   kernel/kexec_kho_out.c:210:26: warning: excess elements in struct initializer
     210 |                 .bufsz = 0,
         |                          ^
   kernel/kexec_kho_out.c:210:26: note: (near initialization for '(anonymous)')
>> kernel/kexec_kho_out.c:211:18: error: 'struct kexec_buf' has no member named 'mem'
     211 |                 .mem = KEXEC_BUF_MEM_UNKNOWN,
         |                  ^~~
>> kernel/kexec_kho_out.c:211:24: error: 'KEXEC_BUF_MEM_UNKNOWN' undeclared (first use in this function)
     211 |                 .mem = KEXEC_BUF_MEM_UNKNOWN,
         |                        ^~~~~~~~~~~~~~~~~~~~~
   kernel/kexec_kho_out.c:211:24: note: each undeclared identifier is reported only once for each function it appears in
   kernel/kexec_kho_out.c:211:24: warning: excess elements in struct initializer
   kernel/kexec_kho_out.c:211:24: note: (near initialization for '(anonymous)')
>> kernel/kexec_kho_out.c:212:18: error: 'struct kexec_buf' has no member named 'memsz'
     212 |                 .memsz = 0,
         |                  ^~~~~
   kernel/kexec_kho_out.c:212:26: warning: excess elements in struct initializer
     212 |                 .memsz = 0,
         |                          ^
   kernel/kexec_kho_out.c:212:26: note: (near initialization for '(anonymous)')
>> kernel/kexec_kho_out.c:213:18: error: 'struct kexec_buf' has no member named 'buf_align'
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
>> kernel/kexec_kho_out.c:214:18: error: 'struct kexec_buf' has no member named 'buf_max'
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
>> kernel/kexec_kho_out.c:215:18: error: 'struct kexec_buf' has no member named 'top_down'
     215 |                 .top_down = true,
         |                  ^~~~~~~~
   kernel/kexec_kho_out.c:215:29: warning: excess elements in struct initializer
     215 |                 .top_down = true,
         |                             ^~~~
   kernel/kexec_kho_out.c:215:29: note: (near initialization for '(anonymous)')
>> kernel/kexec_kho_out.c:207:51: error: invalid use of undefined type 'struct kexec_buf'
     207 |         image->kho.mem_cache = (struct kexec_buf) {
         |                                                   ^
>> kernel/kexec_kho_out.c:231:15: error: implicit declaration of function 'kexec_add_buffer' [-Werror=implicit-function-declaration]
     231 |         err = kexec_add_buffer(&image->kho.mem_cache);
         |               ^~~~~~~~~~~~~~~~
   kernel/kexec_kho_out.c:247:18: error: 'struct kexec_buf' has no member named 'image'
     247 |                 .image = image,
         |                  ^~~~~
   kernel/kexec_kho_out.c:247:26: warning: excess elements in struct initializer
     247 |                 .image = image,
         |                          ^~~~~
   kernel/kexec_kho_out.c:247:26: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:248:18: error: 'struct kexec_buf' has no member named 'buffer'
     248 |                 .buffer = dt,
         |                  ^~~~~~
   kernel/kexec_kho_out.c:248:27: warning: excess elements in struct initializer
     248 |                 .buffer = dt,
         |                           ^~
   kernel/kexec_kho_out.c:248:27: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:249:18: error: 'struct kexec_buf' has no member named 'bufsz'
     249 |                 .bufsz = kho.dt_len,
         |                  ^~~~~
   kernel/kexec_kho_out.c:249:26: warning: excess elements in struct initializer
     249 |                 .bufsz = kho.dt_len,
         |                          ^~~
   kernel/kexec_kho_out.c:249:26: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:250:18: error: 'struct kexec_buf' has no member named 'mem'
     250 |                 .mem = KEXEC_BUF_MEM_UNKNOWN,
         |                  ^~~
   kernel/kexec_kho_out.c:250:24: warning: excess elements in struct initializer
     250 |                 .mem = KEXEC_BUF_MEM_UNKNOWN,
         |                        ^~~~~~~~~~~~~~~~~~~~~
   kernel/kexec_kho_out.c:250:24: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:251:18: error: 'struct kexec_buf' has no member named 'memsz'
     251 |                 .memsz = kho.dt_len,
         |                  ^~~~~
   kernel/kexec_kho_out.c:251:26: warning: excess elements in struct initializer
     251 |                 .memsz = kho.dt_len,
         |                          ^~~
   kernel/kexec_kho_out.c:251:26: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:252:18: error: 'struct kexec_buf' has no member named 'buf_align'
     252 |                 .buf_align = SZ_64K, /* Makes it easier to map */
         |                  ^~~~~~~~~
   include/linux/sizes.h:27:41: warning: excess elements in struct initializer
      27 | #define SZ_64K                          0x00010000
         |                                         ^~~~~~~~~~
   kernel/kexec_kho_out.c:252:30: note: in expansion of macro 'SZ_64K'
     252 |                 .buf_align = SZ_64K, /* Makes it easier to map */
         |                              ^~~~~~
   include/linux/sizes.h:27:41: note: (near initialization for '(anonymous)')
      27 | #define SZ_64K                          0x00010000
         |                                         ^~~~~~~~~~
   kernel/kexec_kho_out.c:252:30: note: in expansion of macro 'SZ_64K'
     252 |                 .buf_align = SZ_64K, /* Makes it easier to map */
         |                              ^~~~~~
   kernel/kexec_kho_out.c:253:18: error: 'struct kexec_buf' has no member named 'buf_max'
     253 |                 .buf_max = ULONG_MAX,
         |                  ^~~~~~~
   include/vdso/limits.h:13:25: warning: excess elements in struct initializer
      13 | #define ULONG_MAX       (~0UL)
         |                         ^
   kernel/kexec_kho_out.c:253:28: note: in expansion of macro 'ULONG_MAX'
     253 |                 .buf_max = ULONG_MAX,
         |                            ^~~~~~~~~
   include/vdso/limits.h:13:25: note: (near initialization for '(anonymous)')
      13 | #define ULONG_MAX       (~0UL)
         |                         ^
   kernel/kexec_kho_out.c:253:28: note: in expansion of macro 'ULONG_MAX'
     253 |                 .buf_max = ULONG_MAX,
         |                            ^~~~~~~~~
   kernel/kexec_kho_out.c:254:18: error: 'struct kexec_buf' has no member named 'top_down'
     254 |                 .top_down = true,
         |                  ^~~~~~~~
   kernel/kexec_kho_out.c:254:29: warning: excess elements in struct initializer
     254 |                 .top_down = true,
         |                             ^~~~
   kernel/kexec_kho_out.c:254:29: note: (near initialization for '(anonymous)')
   kernel/kexec_kho_out.c:246:44: error: invalid use of undefined type 'struct kexec_buf'
     246 |         image->kho.dt = (struct kexec_buf) {
         |                                            ^
   cc1: some warnings being treated as errors


vim +/dt +369 include/linux/kexec.h

9336a5f64b54d2 Lakshmi Ramasubramanian 2021-02-21  366  
4d945e93456555 Alexander Graf          2023-12-12  367  #ifdef CONFIG_KEXEC_KHO
4d945e93456555 Alexander Graf          2023-12-12  368  	struct {
4d945e93456555 Alexander Graf          2023-12-12 @369  		struct kexec_buf dt;
4d945e93456555 Alexander Graf          2023-12-12 @370  		struct kexec_buf mem_cache;
4d945e93456555 Alexander Graf          2023-12-12  371  	} kho;
4d945e93456555 Alexander Graf          2023-12-12  372  #endif
4d945e93456555 Alexander Graf          2023-12-12  373  
9336a5f64b54d2 Lakshmi Ramasubramanian 2021-02-21  374  	/* Core ELF header buffer */
9336a5f64b54d2 Lakshmi Ramasubramanian 2021-02-21  375  	void *elf_headers;
9336a5f64b54d2 Lakshmi Ramasubramanian 2021-02-21  376  	unsigned long elf_headers_sz;
9336a5f64b54d2 Lakshmi Ramasubramanian 2021-02-21  377  	unsigned long elf_load_addr;
cb1052581e2bdd Vivek Goyal             2014-08-08  378  };
dc009d92435f99 Eric W. Biederman       2005-06-25  379  

:::::: The code at line 369 was first introduced by commit
:::::: 4d945e934565554b4f997c57162e833303f56cb0 kexec: Add KHO support to kexec file loads

:::::: TO: Alexander Graf <graf@amazon.com>
:::::: CC: Alexander Graf <graf@amazon.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

