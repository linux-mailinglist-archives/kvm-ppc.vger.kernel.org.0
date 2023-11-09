Return-Path: <kvm-ppc+bounces-7-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4CB7E711B
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 19:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5250B20C06
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 18:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8642231A61;
	Thu,  9 Nov 2023 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LE8s7Hgb"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87102232C
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 18:05:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8A62139
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 10:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699553128; x=1731089128;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Mx+Ha5245rxdOzlmkR05A4nFORMh8Yy/19L1nFArcrc=;
  b=LE8s7HgbXcjcgxUBh27YiqZv0BVxOYSej3xtMYsX3lGVIc7TbJfow3eY
   P4ja68HdVXGVMMUhm2lBmrTMv8u21srsrz/fhZP+6M7udO5SP0DFbuhn9
   90A1L2rwEwdzvfFIfV55iFfMdYbT12tlDK5gEFvX1oxlzfltBmBL4bH6f
   a6Ks7c7Y9PXTL1GdaPg/0N1YAcTD2zshv/a5o//Ygac/LuJvy6HIJWY9V
   mExz98HfUoXqMKFoq8eTlF+/2ZjB2NplGiMFbdOTpC1Fr1FYzYdM75Sa0
   ZX/KIfPG/zgiTQT9oLAFllrHKgkJak12B5uUlBlWOsXPV7h12Faip9ERW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="454346383"
X-IronPort-AV: E=Sophos;i="6.03,290,1694761200"; 
   d="scan'208";a="454346383"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 10:05:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="833900934"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="833900934"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 09 Nov 2023 10:05:25 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r19P9-000922-14;
	Thu, 09 Nov 2023 18:05:23 +0000
Date: Fri, 10 Nov 2023 02:04:19 +0800
From: kernel test robot <lkp@intel.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org,
	cloud-init created default user <ec2-user@ip-172-31-5-41.eu-west-1.compute.internal>,
	Michael Roth <michael.roth@amd.com>
Subject: [agraf-2.6:snp-host-v10 73/108] arch/x86/virt/svm/sev.c:528:6:
 warning: no previous prototype for 'snp_leak_pages'
Message-ID: <202311100252.5NjgsH2N-lkp@intel.com>
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
commit: 294b0ed9a31e2cf5ac043123ae4c1a104e126ed8 [73/108] x86/sev: Introduce snp leaked pages list
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20231110/202311100252.5NjgsH2N-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231110/202311100252.5NjgsH2N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311100252.5NjgsH2N-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/virt/svm/sev.c:286:5: warning: no previous prototype for 'snp_lookup_rmpentry' [-Wmissing-prototypes]
     286 | int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
         |     ^~~~~~~~~~~~~~~~~~~
   arch/x86/virt/svm/sev.c:358:6: warning: no previous prototype for 'sev_dump_hva_rmpentry' [-Wmissing-prototypes]
     358 | void sev_dump_hva_rmpentry(unsigned long hva)
         |      ^~~~~~~~~~~~~~~~~~~~~
   arch/x86/virt/svm/sev.c:381:5: warning: no previous prototype for 'psmash' [-Wmissing-prototypes]
     381 | int psmash(u64 pfn)
         |     ^~~~~~
   arch/x86/virt/svm/sev.c:499:5: warning: no previous prototype for 'rmp_make_private' [-Wmissing-prototypes]
     499 | int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
         |     ^~~~~~~~~~~~~~~~
   arch/x86/virt/svm/sev.c:517:5: warning: no previous prototype for 'rmp_make_shared' [-Wmissing-prototypes]
     517 | int rmp_make_shared(u64 pfn, enum pg_level level)
         |     ^~~~~~~~~~~~~~~
>> arch/x86/virt/svm/sev.c:528:6: warning: no previous prototype for 'snp_leak_pages' [-Wmissing-prototypes]
     528 | void snp_leak_pages(u64 pfn, unsigned int npages)
         |      ^~~~~~~~~~~~~~


vim +/snp_leak_pages +528 arch/x86/virt/svm/sev.c

   376	
   377	/*
   378	 * PSMASH a 2MB aligned page into 4K pages in the RMP table while preserving the
   379	 * Validated bit.
   380	 */
 > 381	int psmash(u64 pfn)
   382	{
   383		unsigned long paddr = pfn << PAGE_SHIFT;
   384		int ret;
   385	
   386		pr_debug("%s: PFN: 0x%llx\n", __func__, pfn);
   387	
   388		if (!pfn_valid(pfn))
   389			return -EINVAL;
   390	
   391		if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
   392			return -ENXIO;
   393	
   394		/* Binutils version 2.36 supports the PSMASH mnemonic. */
   395		asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
   396			      : "=a"(ret)
   397			      : "a"(paddr)
   398			      : "memory", "cc");
   399	
   400		return ret;
   401	}
   402	EXPORT_SYMBOL_GPL(psmash);
   403	
   404	static int restore_direct_map(u64 pfn, int npages)
   405	{
   406		int i, ret = 0;
   407	
   408		for (i = 0; i < npages; i++) {
   409			ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
   410			if (ret)
   411				break;
   412		}
   413	
   414		if (ret)
   415			pr_warn("Failed to restore direct map for pfn 0x%llx, ret: %d\n",
   416				pfn + i, ret);
   417	
   418		return ret;
   419	}
   420	
   421	static int invalidate_direct_map(u64 pfn, int npages)
   422	{
   423		int i, ret = 0;
   424	
   425		for (i = 0; i < npages; i++) {
   426			ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
   427			if (ret)
   428				break;
   429		}
   430	
   431		if (ret) {
   432			pr_warn("Failed to invalidate direct map for pfn 0x%llx, ret: %d\n",
   433				pfn + i, ret);
   434			restore_direct_map(pfn, i);
   435		}
   436	
   437		return ret;
   438	}
   439	
   440	static int rmpupdate(u64 pfn, struct rmp_state *val)
   441	{
   442		unsigned long paddr = pfn << PAGE_SHIFT;
   443		int ret, level, npages;
   444		int attempts = 0;
   445	
   446		if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
   447			return -ENXIO;
   448	
   449		level = RMP_TO_X86_PG_LEVEL(val->pagesize);
   450		npages = page_level_size(level) / PAGE_SIZE;
   451	
   452		/*
   453		 * If page is getting assigned in the RMP table then unmap it from the
   454		 * direct map.
   455		 */
   456		if (val->assigned) {
   457			if (invalidate_direct_map(pfn, npages)) {
   458				pr_err("Failed to unmap %d pages at pfn 0x%llx from the direct_map\n",
   459				       npages, pfn);
   460				return -EFAULT;
   461			}
   462		}
   463	
   464		do {
   465			/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
   466			asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
   467				     : "=a"(ret)
   468				     : "a"(paddr), "c"((unsigned long)val)
   469				     : "memory", "cc");
   470	
   471			attempts++;
   472		} while (ret == RMPUPDATE_FAIL_OVERLAP);
   473	
   474		if (ret) {
   475			pr_err("RMPUPDATE failed after %d attempts, ret: %d, pfn: %llx, npages: %d, level: %d\n",
   476			       attempts, ret, pfn, npages, level);
   477			sev_dump_rmpentry(pfn);
   478			dump_stack();
   479			return -EFAULT;
   480		}
   481	
   482		/*
   483		 * Restore the direct map after the page is removed from the RMP table.
   484		 */
   485		if (!val->assigned) {
   486			if (restore_direct_map(pfn, npages)) {
   487				pr_err("Failed to map %d pages at pfn 0x%llx into the direct_map\n",
   488				       npages, pfn);
   489				return -EFAULT;
   490			}
   491		}
   492	
   493		return 0;
   494	}
   495	
   496	/*
   497	 * Assign a page to guest using the RMPUPDATE instruction.
   498	 */
   499	int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
   500	{
   501		struct rmp_state val;
   502	
   503		memset(&val, 0, sizeof(val));
   504		val.assigned = 1;
   505		val.asid = asid;
   506		val.immutable = immutable;
   507		val.gpa = gpa;
   508		val.pagesize = X86_TO_RMP_PG_LEVEL(level);
   509	
   510		return rmpupdate(pfn, &val);
   511	}
   512	EXPORT_SYMBOL_GPL(rmp_make_private);
   513	
   514	/*
   515	 * Transition a page to hypervisor/shared state using the RMPUPDATE instruction.
   516	 */
   517	int rmp_make_shared(u64 pfn, enum pg_level level)
   518	{
   519		struct rmp_state val;
   520	
   521		memset(&val, 0, sizeof(val));
   522		val.pagesize = X86_TO_RMP_PG_LEVEL(level);
   523	
   524		return rmpupdate(pfn, &val);
   525	}
   526	EXPORT_SYMBOL_GPL(rmp_make_shared);
   527	
 > 528	void snp_leak_pages(u64 pfn, unsigned int npages)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

