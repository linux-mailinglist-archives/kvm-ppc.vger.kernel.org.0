Return-Path: <kvm-ppc+bounces-6-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA07E7E700B
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 18:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CBAB280E32
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 17:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB4E22316;
	Thu,  9 Nov 2023 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z4vz6pVG"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ECA2231C
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 17:19:35 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED3E30D5
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 09:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699550374; x=1731086374;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=aSIpJnrLC5nvszml9GBGiRTP4h1SzuQFN8Xd1BHpRcs=;
  b=Z4vz6pVGAijuMK0dglvnP8v2iRKQgslgg7OoK9yvd3+CMbw1JSBMBF/Z
   h2sZUX2nIyVxVEJC5Xil6s7kxHU+nRMtA+TSQmqJbYdpwxyrsiF+nVXm+
   mFzsxLrDlOB+RBw2tEC6gxPi+UU4WEk7KYwmsyqln6izefx5z6Ydw3UiL
   xhjim+Nnp5BUTtlDPWZAYD9ymmQkVt0454R9tQ6L19s7JaTqMJ49depW1
   Mw53UpBYItKwBJ96/lZ0TlPzzUryX7MlrJLQXgVWaeGMCErR4fjckOUJv
   fjx1dpKzaVw4A6/paLqVwACaRpcnTRa6iwxnoNf2TszTkPzktUoQp2Cu3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="392902168"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="392902168"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 09:19:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="767068448"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="767068448"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 09 Nov 2023 09:19:31 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r18gj-0008xK-31;
	Thu, 09 Nov 2023 17:19:29 +0000
Date: Fri, 10 Nov 2023 00:46:56 +0800
From: kernel test robot <lkp@intel.com>
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org,
	cloud-init created default user <ec2-user@ip-172-31-5-41.eu-west-1.compute.internal>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [agraf-2.6:snp-host-v10 68/108] arch/x86/virt/svm/sev.c:375:5:
 warning: no previous prototype for 'psmash'
Message-ID: <202311092313.6740yf0y-lkp@intel.com>
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
commit: e57dbd72a4490baee2e82f45835580ac5c2d44bf [68/108] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20231109/202311092313.6740yf0y-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231109/202311092313.6740yf0y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311092313.6740yf0y-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/virt/svm/sev.c:280:5: warning: no previous prototype for 'snp_lookup_rmpentry' [-Wmissing-prototypes]
     280 | int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
         |     ^~~~~~~~~~~~~~~~~~~
   arch/x86/virt/svm/sev.c:352:6: warning: no previous prototype for 'sev_dump_hva_rmpentry' [-Wmissing-prototypes]
     352 | void sev_dump_hva_rmpentry(unsigned long hva)
         |      ^~~~~~~~~~~~~~~~~~~~~
>> arch/x86/virt/svm/sev.c:375:5: warning: no previous prototype for 'psmash' [-Wmissing-prototypes]
     375 | int psmash(u64 pfn)
         |     ^~~~~~
>> arch/x86/virt/svm/sev.c:431:5: warning: no previous prototype for 'rmp_make_private' [-Wmissing-prototypes]
     431 | int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
         |     ^~~~~~~~~~~~~~~~
>> arch/x86/virt/svm/sev.c:449:5: warning: no previous prototype for 'rmp_make_shared' [-Wmissing-prototypes]
     449 | int rmp_make_shared(u64 pfn, enum pg_level level)
         |     ^~~~~~~~~~~~~~~


vim +/psmash +375 arch/x86/virt/svm/sev.c

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
   353	{
   354		unsigned int level;
   355		pgd_t *pgd;
   356		pte_t *pte;
   357	
   358		pgd = __va(read_cr3_pa());
   359		pgd += pgd_index(hva);
   360		pte = lookup_address_in_pgd(pgd, hva, &level);
   361	
   362		if (pte) {
   363			pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
   364			return;
   365		}
   366	
   367		sev_dump_rmpentry(pte_pfn(*pte));
   368	}
   369	EXPORT_SYMBOL_GPL(sev_dump_hva_rmpentry);
   370	
   371	/*
   372	 * PSMASH a 2MB aligned page into 4K pages in the RMP table while preserving the
   373	 * Validated bit.
   374	 */
 > 375	int psmash(u64 pfn)
   376	{
   377		unsigned long paddr = pfn << PAGE_SHIFT;
   378		int ret;
   379	
   380		pr_debug("%s: PFN: 0x%llx\n", __func__, pfn);
   381	
   382		if (!pfn_valid(pfn))
   383			return -EINVAL;
   384	
   385		if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
   386			return -ENXIO;
   387	
   388		/* Binutils version 2.36 supports the PSMASH mnemonic. */
   389		asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
   390			      : "=a"(ret)
   391			      : "a"(paddr)
   392			      : "memory", "cc");
   393	
   394		return ret;
   395	}
   396	EXPORT_SYMBOL_GPL(psmash);
   397	
   398	static int rmpupdate(u64 pfn, struct rmp_state *val)
   399	{
   400		unsigned long paddr = pfn << PAGE_SHIFT;
   401		int ret, level, npages;
   402		int attempts = 0;
   403	
   404		if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
   405			return -ENXIO;
   406	
   407		do {
   408			/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
   409			asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
   410				     : "=a"(ret)
   411				     : "a"(paddr), "c"((unsigned long)val)
   412				     : "memory", "cc");
   413	
   414			attempts++;
   415		} while (ret == RMPUPDATE_FAIL_OVERLAP);
   416	
   417		if (ret) {
   418			pr_err("RMPUPDATE failed after %d attempts, ret: %d, pfn: %llx, npages: %d, level: %d\n",
   419			       attempts, ret, pfn, npages, level);
   420			sev_dump_rmpentry(pfn);
   421			dump_stack();
   422			return -EFAULT;
   423		}
   424	
   425		return 0;
   426	}
   427	
   428	/*
   429	 * Assign a page to guest using the RMPUPDATE instruction.
   430	 */
 > 431	int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
   432	{
   433		struct rmp_state val;
   434	
   435		memset(&val, 0, sizeof(val));
   436		val.assigned = 1;
   437		val.asid = asid;
   438		val.immutable = immutable;
   439		val.gpa = gpa;
   440		val.pagesize = X86_TO_RMP_PG_LEVEL(level);
   441	
   442		return rmpupdate(pfn, &val);
   443	}
   444	EXPORT_SYMBOL_GPL(rmp_make_private);
   445	
   446	/*
   447	 * Transition a page to hypervisor/shared state using the RMPUPDATE instruction.
   448	 */
 > 449	int rmp_make_shared(u64 pfn, enum pg_level level)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

