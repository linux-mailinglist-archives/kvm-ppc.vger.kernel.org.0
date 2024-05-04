Return-Path: <kvm-ppc+bounces-101-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA1A8BBD86
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 20:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 737F41C20D51
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 18:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DD15FDD3;
	Sat,  4 May 2024 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcD7/rxj"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499A73B29D
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714845706; cv=none; b=H7uaCluLci7NF7YXxGFw5I9uiH1/+c/Y9nOa/dvviJ0U9r3ia7ctW0Xz68E8fWQHpZegD1Sox9QDeyBUaof/mcz+tf7Iphxk4AZERZjMBGihhdnU3xT89KH5RuII01rVQhNfltW6FwuUQb1gvHsjLLzgVBevCfftOsleaff7EfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714845706; c=relaxed/simple;
	bh=CJyndH132PyZbSDkkvk1fLFsu4IFHGh/caTalDMZGNA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BnBTaQQ3/EqQqoX8tTX/7/OxK0PZ3Z6rOIQx0Ll2vXM6vlPrvwB3w7Vve2f9Jf2oqu8TcoUVTyc9NuvF4/2YyvRURUR4DPj2hJF3B/doEIJKqraR1i4tHf4tmLVQhhbYguNNEbxzJrCHnkiyNjyPWwFiwclqb/vMsjdp1GKZT3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcD7/rxj; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714845705; x=1746381705;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=CJyndH132PyZbSDkkvk1fLFsu4IFHGh/caTalDMZGNA=;
  b=KcD7/rxjcB5PZHl8nL0XYahWrRrUDU7VtolFoYTeJe1kSgjsTLDN03O1
   X3HZQvZ3vOpqvQPM+U/o6fcbHcoUyWk151w2X7gA/P47PoIKMufS8p2pi
   LI7Z1NVgICWpYd46xqCoRdobihmI0/TOJKi9QRUiftoIibr+9j2/Xwx5a
   kgWPgDBAHCHAC0W1/iIMZByrU9q+j8iko6cn+fUVMOoTlpzyeOTofu13m
   d8DMtx9So/T3Y3lzkLrYucOcj9pv6ZJO+uQ/7U/UVpU69WNtChDfzED3y
   c6AAKE0VHK/4cIKqlZCu3vdyDObV4i2pu48zqAvwpl8yGoZYfuMXj2DwB
   w==;
X-CSE-ConnectionGUID: 5aGXGqCdRGu7v7Fj7ebB6w==
X-CSE-MsgGUID: KSJU627DRUOGmd8Taf3Zig==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="10487392"
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="10487392"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 11:01:44 -0700
X-CSE-ConnectionGUID: xVWCS8SfS6C07xy9wRI55g==
X-CSE-MsgGUID: 87T944gpSAexNbbYJgtjow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="32562282"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 04 May 2024 11:01:42 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3Jhb-000D2m-36;
	Sat, 04 May 2024 18:01:39 +0000
Date: Sun, 5 May 2024 02:01:01 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 5/27] include/linux/kexec.h:537:42:
 warning: declaration of 'struct kimage' will not be visible outside of this
 function
Message-ID: <202405050113.Kgjow73K-lkp@intel.com>
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
commit: 4d945e934565554b4f997c57162e833303f56cb0 [5/27] kexec: Add KHO support to kexec file loads
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20240505/202405050113.Kgjow73K-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 37ae4ad0eef338776c7e2cffb3896153d43dcd90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050113.Kgjow73K-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050113.Kgjow73K-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from kernel/panic.c:15:
   In file included from include/linux/kgdb.h:19:
   In file included from include/linux/kprobes.h:28:
   In file included from include/linux/ftrace.h:13:
   In file included from include/linux/kallsyms.h:13:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from kernel/panic.c:25:
>> include/linux/kexec.h:537:42: warning: declaration of 'struct kimage' will not be visible outside of this function [-Wvisibility]
     537 | static inline int kho_fill_kimage(struct kimage *image) { return 0; }
         |                                          ^
   2 warnings generated.


vim +537 include/linux/kexec.h

   534	
   535	/* egest handover metadata */
   536	static inline void kho_reserve_scratch(void) { }
 > 537	static inline int kho_fill_kimage(struct kimage *image) { return 0; }
   538	static inline int register_kho_notifier(struct notifier_block *nb) { return -EINVAL; }
   539	static inline int unregister_kho_notifier(struct notifier_block *nb) { return -EINVAL; }
   540	static inline bool kho_is_active(void) { return false; }
   541	#endif
   542	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

