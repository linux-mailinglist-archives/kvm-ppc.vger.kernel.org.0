Return-Path: <kvm-ppc+bounces-5-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E72177E6BF2
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 15:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23FA61C209DB
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 14:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57D21DFFF;
	Thu,  9 Nov 2023 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K3RN5PsF"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA661E522
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 14:03:08 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782012D77
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 06:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699538587; x=1731074587;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=mADaHuQaz4lecY4mrCA06VE+sWfe1JKJkNX0cjZX0B8=;
  b=K3RN5PsF7II2bLg0MljQ/rHzTeVvVEZuQqMjlt/fkXyTiHw3I3lTj2YP
   y7iuDPbGiCkxGzvLniw3QlyTxcxHv60g6mSl9tz4zOgHdCMvkBwzWv2AC
   9ozyT6XMg4IipwnawFx+M5Kp7ZK+1V2Z89TyUSdM5PR36cRClz+uYd3Nr
   Hq8/MeyKeGPdMqqE52meNyxCAa946pg1xPHfLi7J43hVtuvnv3+l4Oa9c
   Y3AMVgMkSI14D39SC+gn23AMCaklAG8CoMu4k+EypminKKpqdLDTRQGsy
   rO0mTH21hoLBSNGjZJoB9zI1nL7We8zVioZmNRmeFPcAhDuIly1S/Cxnb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="380379253"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="380379253"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 06:03:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="4727962"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Nov 2023 06:03:00 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r15cX-0008lw-2p;
	Thu, 09 Nov 2023 14:02:57 +0000
Date: Thu, 9 Nov 2023 22:02:30 +0800
From: kernel test robot <lkp@intel.com>
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org,
	cloud-init created default user <ec2-user@ip-172-31-5-41.eu-west-1.compute.internal>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [agraf-2.6:snp-host-v10 65/108] arch/x86/virt/svm/sev.c:352:6:
 warning: no previous prototype for 'sev_dump_hva_rmpentry'
Message-ID: <202311092152.UjfN6FW5-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/agraf/linux-2.6.git snp-host-v10
head:   689d7ab69df8f6bff29bd1dbefe7c07bba52a9ac
commit: 7187f30c29e7c30b39e34bb3ab06ecbf034800ab [65/108] x86/fault: Add helper for dumping RMP entries
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20231109/202311092152.UjfN6FW5-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231109/202311092152.UjfN6FW5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311092152.UjfN6FW5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/virt/svm/sev.c:280:5: warning: no previous prototype for 'snp_lookup_rmpentry' [-Wmissing-prototypes]
     280 | int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
         |     ^~~~~~~~~~~~~~~~~~~
>> arch/x86/virt/svm/sev.c:352:6: warning: no previous prototype for 'sev_dump_hva_rmpentry' [-Wmissing-prototypes]
     352 | void sev_dump_hva_rmpentry(unsigned long hva)
         |      ^~~~~~~~~~~~~~~~~~~~~


vim +/sev_dump_hva_rmpentry +352 arch/x86/virt/svm/sev.c

   279	
 > 280	int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
   281	{
   282		struct rmpentry e;
   283		int ret;
   284	
   285		ret = __snp_lookup_rmpentry(pfn, &e, level);
   286		if (ret)
   287			return ret;
   288	
   289		*assigned = !!e.assigned;
   290		return 0;
   291	}
   292	EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
   293	
   294	/*
   295	 * Dump the raw RMP entry for a particular PFN. These bits are documented in the
   296	 * PPR for a particular CPU model and provide useful information about how a
   297	 * particular PFN is being utilized by the kernel/firmware at the time certain
   298	 * unexpected events occur, such as RMP faults.
   299	 */
   300	static void sev_dump_rmpentry(u64 dumped_pfn)
   301	{
   302		struct rmpentry e;
   303		u64 pfn, pfn_end;
   304		int level, ret;
   305		u64 *e_data;
   306	
   307		ret = __snp_lookup_rmpentry(dumped_pfn, &e, &level);
   308		if (ret) {
   309			pr_info("Failed to read RMP entry for PFN 0x%llx, error %d\n",
   310				dumped_pfn, ret);
   311			return;
   312		}
   313	
   314		e_data = (u64 *)&e;
   315		if (e.assigned) {
   316			pr_info("RMP entry for PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
   317				dumped_pfn, e_data[1], e_data[0]);
   318			return;
   319		}
   320	
   321		/*
   322		 * If the RMP entry for a particular PFN is not in an assigned state,
   323		 * then it is sometimes useful to get an idea of whether or not any RMP
   324		 * entries for other PFNs within the same 2MB region are assigned, since
   325		 * those too can affect the ability to access a particular PFN in
   326		 * certain situations, such as when the PFN is being accessed via a 2MB
   327		 * mapping in the host page table.
   328		 */
   329		pfn = ALIGN(dumped_pfn, PTRS_PER_PMD);
   330		pfn_end = pfn + PTRS_PER_PMD;
   331	
   332		while (pfn < pfn_end) {
   333			ret = __snp_lookup_rmpentry(pfn, &e, &level);
   334			if (ret) {
   335				pr_info_ratelimited("Failed to read RMP entry for PFN 0x%llx\n", pfn);
   336				pfn++;
   337				continue;
   338			}
   339	
   340			if (e_data[0] || e_data[1]) {
   341				pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
   342					dumped_pfn, pfn, e_data[1], e_data[0]);
   343				return;
   344			}
   345			pfn++;
   346		}
   347	
   348		pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
   349			dumped_pfn);
   350	}
   351	
 > 352	void sev_dump_hva_rmpentry(unsigned long hva)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

