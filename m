Return-Path: <kvm-ppc+bounces-263-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0846AB5372
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 May 2025 13:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A35EF16B72E
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 May 2025 11:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FAF828C5AE;
	Tue, 13 May 2025 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tvz5IKp2"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA028C5D3
	for <kvm-ppc@vger.kernel.org>; Tue, 13 May 2025 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747134320; cv=none; b=QtqFWiZvBHxQI61g9Fv0A7HVH9ce4Ql0ZRdQ+csiyPE9rDxuobKrBa8913mUqqd6rfPbc1P+mtwLX1wlRz6C5q/q4Yid+4h4pY00txAdUgpk4hxPe6hEUquJ4Mb0TXAiGdIZYwkwZpDo8wfvjGykZX/h9qQpTIQHm7IbCIdHzvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747134320; c=relaxed/simple;
	bh=TyKZ4ZhApYcK07LD20S9qIReis/bbKeYVVpUi1QMLJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bHv37TPlSnCA56AJE7ftXXctqsXNNBftP8MEUHa41urdiIyahn5NzQIvEW5NI59n0Rqhk7RCAd5S4Zy6lYEw08hfdRlCe7LtLuVeGkRnwTWadMRhpLuoI2UQ9zBBqPSLaMNA895CKppRtCG2MdhjKAtfjEjREjzea6OrJpp3oNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tvz5IKp2; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747134318; x=1778670318;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=TyKZ4ZhApYcK07LD20S9qIReis/bbKeYVVpUi1QMLJ8=;
  b=Tvz5IKp2EIqayGlSvgk1fh9VRzxpmvcQ11mEezhF9GC0aDy3AimXjzH5
   FqlWOYnRJF8IN+ED8/2/jKdSHzQTaYs/x/15xsACj3KjFFEmUEiE2rZ+N
   1o1l6jSK/6+Is+htGDcBjBqloqwKMhgsUFv0eTTYikEf3LszcFwtK6DFE
   d8y7UJ4AiCODXVellP3GVSla82HHBiBn5Pw3aKqaWU7RYfnDFurH5RwId
   b7Ygj5ZxxqeaQE1VT22KDdreFskS9uJoRHSB5wAG5CQeSmvUpMp9PKV5V
   2ZJv5K00yigFwYeQwcA09NkonjlebLONhTn55Fu/txLU74V3nCbdd8x6b
   w==;
X-CSE-ConnectionGUID: Du94H0LRQTKzfSP7fzCCHg==
X-CSE-MsgGUID: TxA9IZEeSeaj9WVuqd5kBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48665812"
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="48665812"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 04:05:18 -0700
X-CSE-ConnectionGUID: adWpC4XUQcSMBal4XoAcTA==
X-CSE-MsgGUID: sfXTwCP3Ra+/6cllyBhfsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="142566870"
Received: from igk-lkp-server01.igk.intel.com (HELO b9ffd1689040) ([10.211.3.150])
  by fmviesa005.fm.intel.com with ESMTP; 13 May 2025 04:05:17 -0700
Received: from kbuild by b9ffd1689040 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uEnRi-0000vm-2L;
	Tue, 13 May 2025 11:05:14 +0000
Date: Tue, 13 May 2025 19:04:32 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kexec-cma 2/2] include/linux/kern_levels.h:5:25: warning:
 format '%d' expects argument of type 'int', but argument 2 has type 'long
 unsigned int'
Message-ID: <202505131907.gsHkoQ4z-lkp@intel.com>
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
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250513/202505131907.gsHkoQ4z-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250513/202505131907.gsHkoQ4z-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505131907.gsHkoQ4z-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:103,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from kernel/kexec_file.c:13:
   kernel/kexec_file.c: In function 'kexec_alloc_contig':
>> include/linux/kern_levels.h:5:25: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:479:25: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:560:9: note: in expansion of macro 'printk'
     560 |         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:12:25: note: in expansion of macro 'KERN_SOH'
      12 | #define KERN_WARNING    KERN_SOH "4"    /* warning conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:560:16: note: in expansion of macro 'KERN_WARNING'
     560 |         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~~~~~
   kernel/kexec_file.c:661:9: note: in expansion of macro 'pr_warn'
     661 |         pr_warn("Allocated %d pages DMA memory\n", kbuf->memsz >> PAGE_SHIFT);
         |         ^~~~~~~


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

:::::: The code at line 5 was first introduced by commit
:::::: 04d2c8c83d0e3ac5f78aeede51babb3236200112 printk: convert the format for KERN_<LEVEL> to a 2 byte pattern

:::::: TO: Joe Perches <joe@perches.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

