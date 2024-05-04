Return-Path: <kvm-ppc+bounces-107-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 115E88BBDC9
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 21:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45637B2136C
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 19:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570EC74416;
	Sat,  4 May 2024 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fhy+sav+"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8491DDF6
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 19:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714849669; cv=none; b=CHp2FskY55D7bPahSpyeOZNHXY7kiKYAv9pbU30q8W3PuPjJG/hUItGPSMa3ZGig8n4OII+N4xiWfMSGxj7XZ2QL5p5wisM/qtHkm+V4DxGjxmlKzItA5vWZZd7/LaPDhM9urpWD6y0hCyFb+giTGAVasmjvf9nJhpJVyVwb2wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714849669; c=relaxed/simple;
	bh=Bn5OCPgnnnAJgLYB8urvyWd76V5wsD6EF/aRqDYSAZA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eBDegq4i2ZGQWVF/Kxn7FmPSQuMGxwMxaMimyhOpgnDuH2fFetKlE2HyK/91FAJk45ehGshLzeWDU6OODZjgjNLMcW7TdNw7oUr4tRRebW4Sv0GFaUSFkiXDlV2FFJM+NdkNFYGtJ/vfcWHFpSUJX1GUSQ2uXPV+lOOCPBFz9IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fhy+sav+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714849666; x=1746385666;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Bn5OCPgnnnAJgLYB8urvyWd76V5wsD6EF/aRqDYSAZA=;
  b=fhy+sav+siqXmtFAUewuDx2U1prpWqm8YMaH6CJY2SGDRwzS22isAqCb
   3dQ3UI3qurA35Ml0nPAtJU1pB7hKvsp1l+k2rRcRhHrk35boDD4GOHk3p
   03022KLCWiFJngLzrl790syLujOl31Mf2gekOctleVePe+qk60nL12fxo
   iDZEIPmIoFvP9qQxv4aB0wCoay2V2hE0uSfe4R3qH/ZdnZh7u4HSJ4ELd
   UcINgRtQoDbuHTn6jRt+WcwBjRWsdUWoJgLRhVNVlrvIwUk/fSCU5vLYY
   PTP7/KN033KQhr1WIu11uOU5OByWHhNXctl2M7IchZEYNafMTF9Y9r36y
   g==;
X-CSE-ConnectionGUID: U4myIZNdT2WYbYrBB4gc5Q==
X-CSE-MsgGUID: wCI+SkYGS5We1iCs1Gd8AA==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="21792286"
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="21792286"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 12:07:46 -0700
X-CSE-ConnectionGUID: tQOCUuirSgmGGGshzxHU3w==
X-CSE-MsgGUID: fYVl3ue4RYivKjj3/SPGbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="32229092"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 04 May 2024 12:07:45 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3KjW-000D6E-3A;
	Sat, 04 May 2024 19:07:42 +0000
Date: Sun, 5 May 2024 03:06:47 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 26/27] kernel/time/sched_clock.c:76:49:
 error: call to undeclared function 'read_sysreg'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202405050255.uiq0NPjq-lkp@intel.com>
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
commit: 12b2509463b155fec805d7fb2ecbef3aafbd2414 [26/27] XXX arm: make early time stamps contiguous
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20240505/202405050255.uiq0NPjq-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 37ae4ad0eef338776c7e2cffb3896153d43dcd90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050255.uiq0NPjq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050255.uiq0NPjq-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/time/sched_clock.c:76:49: error: call to undeclared function 'read_sysreg'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      76 |                 clocks_calc_mult_shift(&rd->mult, &rd->shift, read_sysreg(cntfrq_el0), NSEC_PER_SEC, 600);
         |                                                               ^
>> kernel/time/sched_clock.c:76:61: error: use of undeclared identifier 'cntfrq_el0'
      76 |                 clocks_calc_mult_shift(&rd->mult, &rd->shift, read_sysreg(cntfrq_el0), NSEC_PER_SEC, 600);
         |                                                                           ^
   kernel/time/sched_clock.c:183:27: warning: variable 'new_epoch' set but not used [-Wunused-but-set-variable]
     183 |         u64 res, wrap, new_mask, new_epoch, cyc, ns;
         |                                  ^
   kernel/time/sched_clock.c:183:43: warning: variable 'ns' set but not used [-Wunused-but-set-variable]
     183 |         u64 res, wrap, new_mask, new_epoch, cyc, ns;
         |                                                  ^
   2 warnings and 2 errors generated.


vim +/read_sysreg +76 kernel/time/sched_clock.c

    69	
    70	static void cd_early_init(void)
    71	{
    72		static bool is_initialized;
    73		struct clock_read_data *rd = &cd.read_data[0];
    74	
    75		if (!is_initialized) {
  > 76			clocks_calc_mult_shift(&rd->mult, &rd->shift, read_sysreg(cntfrq_el0), NSEC_PER_SEC, 600);
    77			is_initialized = true;
    78		}
    79	}
    80	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

