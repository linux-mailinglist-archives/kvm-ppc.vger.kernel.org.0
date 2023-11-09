Return-Path: <kvm-ppc+bounces-3-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0838B7E66B3
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 10:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80376B20BF1
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Nov 2023 09:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B57111B2;
	Thu,  9 Nov 2023 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="deilAwDt"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3F11C92
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 09:26:00 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FE426B1
	for <kvm-ppc@vger.kernel.org>; Thu,  9 Nov 2023 01:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699521959; x=1731057959;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=e47JSnZkoA/TYX1ku4+6JJTIAjCUDI8WTlTp65AsOlI=;
  b=deilAwDtfymotB883LxMMybHezt/79ij5C5a5wxskE8OpzNmsj+QHZZF
   QmKd8n94SAhQfF+5kwCAaFkq1H2fqvQ7Xr6asR8eY+QxWRDGdOn7N/CmE
   HGKL86E69pJkfXbUSaC7JmlwtlH4IDNJGQ0gPysljgpLozSsgSEsAFtkM
   3uYinuK9VJ3HzbnwcdFV2zbtCGkuG83vsppPX1pXzWsJUo7WTKNzDtZlg
   Hu/iq6DcIwLq45sRH5J0/xCYlPMKTnLxYHjyH9w8yNZHhJlnaf/x5eqSb
   8V3EOIYq7D3EhY6w2ASK/RumPu15CbaZJIAKJ6UqEnESyeWqLpDmuWGGJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="392821473"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="392821473"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 01:25:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="739795046"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="739795046"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 09 Nov 2023 01:25:57 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r11IR-0008cR-01;
	Thu, 09 Nov 2023 09:25:55 +0000
Date: Thu, 9 Nov 2023 17:25:14 +0800
From: kernel test robot <lkp@intel.com>
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org,
	cloud-init created default user <ec2-user@ip-172-31-5-41.eu-west-1.compute.internal>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [agraf-2.6:snp-host-v10 63/108] arch/x86/kernel/cpu/amd.c:634:14:
 error: 'max_pfn' undeclared; did you mean 'vmap_pfn'?
Message-ID: <202311091744.Puw4ffC4-lkp@intel.com>
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
commit: 9aff2751f0009caae3c39b5f35bada15527db636 [63/108] x86/sev: Add the host SEV-SNP initialization support
config: i386-randconfig-012-20231108 (https://download.01.org/0day-ci/archive/20231109/202311091744.Puw4ffC4-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231109/202311091744.Puw4ffC4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311091744.Puw4ffC4-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kernel/cpu/amd.c: In function 'early_rmptable_check':
>> arch/x86/kernel/cpu/amd.c:634:14: error: 'max_pfn' undeclared (first use in this function); did you mean 'vmap_pfn'?
     634 |         if (!max_pfn)
         |              ^~~~~~~
         |              vmap_pfn
   arch/x86/kernel/cpu/amd.c:634:14: note: each undeclared identifier is reported only once for each function it appears in


vim +634 arch/x86/kernel/cpu/amd.c

   625	
   626	static bool early_rmptable_check(void)
   627	{
   628		u64 rmp_base, rmp_size;
   629	
   630		/*
   631		 * For early BSP initialization, max_pfn won't be set up yet, wait until
   632		 * it is set before performing the RMP table calculations.
   633		 */
 > 634		if (!max_pfn)
   635			return true;
   636	
   637		return snp_get_rmptable_info(&rmp_base, &rmp_size);
   638	}
   639	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

