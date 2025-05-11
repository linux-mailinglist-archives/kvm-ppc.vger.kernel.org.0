Return-Path: <kvm-ppc+bounces-262-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A0BAB2685
	for <lists+kvm-ppc@lfdr.de>; Sun, 11 May 2025 06:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 153E8165569
	for <lists+kvm-ppc@lfdr.de>; Sun, 11 May 2025 04:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A5333987;
	Sun, 11 May 2025 04:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bxjv9eev"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152CE57C93
	for <kvm-ppc@vger.kernel.org>; Sun, 11 May 2025 04:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746936245; cv=none; b=Ayro6lzwHUKnhKJrHE2hJxJ4uxpDVkoUXr3CBd3mBmXLv+3ghdfrfe65JBBoOU48NDorpNkJm6kSc97sKCTlDzlAOKp2yDFrI19jCYPPCHk8iMLrTijW0wCqg5NO33bFvG3/F1WhA1aS/3UhsTQF7mSZY0I/DTqe/0J95d52cjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746936245; c=relaxed/simple;
	bh=2XaOSMgkkemyPrEYbDxWXHGcixNSE4cw/rGWOMObhjw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g7aUaO4zdJ8bB1wLKYpEwsUjlA14vNTlJbXr/zlBRvPB0HYIsfbKGNObs7XoYgwvTJeFf0lcIKsDbsChCvnJODUXTwWh6y0TPRXksv3pws+npwcrXYwF7383nT23DR8svqf/8HkvKeoS5Wn8pa14TbfFCGmuhhsqhGlQANoHOqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bxjv9eev; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746936244; x=1778472244;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2XaOSMgkkemyPrEYbDxWXHGcixNSE4cw/rGWOMObhjw=;
  b=Bxjv9eevZ+x9Dmw9E7dR4b8Te44df9lOvD+zF1GUisa2imQLix+7Cgpe
   oTsrY46TmUk8norcQPLAuVZU8+a/UJLsHISK06pWp+iM3iTb5yvW+tBKo
   4c7laWwKuIzwrrCe9C6lgq1LcR3sghvsLf+WAPBx03ZMc4+EA7GSBxPfU
   v5V/Z/QjSwCsVK//E1v5utmIwLIP2Be1ERuCl1NvRl1Jc84kfoaXaKQ7b
   pHbKc6mOe4MPkVYsLpf+Dt2wt9f1nn3A+fd3sXil3ZYCfuupL5mSRcsZj
   VVubvnXQDcNtirsWSGFV5M3UnYlUSue47qDvnh0SM5mPxvWj5DbGjesab
   A==;
X-CSE-ConnectionGUID: rApaZMBaS4SRDRGjZsaNZw==
X-CSE-MsgGUID: 0KrAxz7HTeKTonls8BBlPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11429"; a="48668476"
X-IronPort-AV: E=Sophos;i="6.15,278,1739865600"; 
   d="scan'208";a="48668476"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2025 21:04:03 -0700
X-CSE-ConnectionGUID: 0UKWAtatS7WkCtdG/QPWLA==
X-CSE-MsgGUID: ZYwUdCuaQviaaVWz/3ybQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,278,1739865600"; 
   d="scan'208";a="160297301"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 10 May 2025 21:04:02 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uDxuy-000Da3-1s;
	Sun, 11 May 2025 04:04:00 +0000
Date: Sun, 11 May 2025 12:03:20 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kexec-cma 2/2] kernel/kexec_core.c:322
 kimage_free_pages() warn: inconsistent indenting
Message-ID: <202505111440.nvpCp0Tw-lkp@intel.com>
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
config: x86_64-randconfig-161-20250510 (https://download.01.org/0day-ci/archive/20250511/202505111440.nvpCp0Tw-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505111440.nvpCp0Tw-lkp@intel.com/

smatch warnings:
kernel/kexec_core.c:322 kimage_free_pages() warn: inconsistent indenting
kernel/kexec_core.c:717 kimage_alloc_page() warn: inconsistent indenting

vim +322 kernel/kexec_core.c

   307	
   308	static void kimage_free_pages(struct page *page)
   309	{
   310		unsigned int order, count, i;
   311	
   312		order = page_private(page);
   313		count = 1 << order;
   314	
   315		arch_kexec_pre_free_pages(page_address(page), count);
   316	
   317		/*
   318		 * CMA pages are always kept at PAGE_SIZE granule in dest_pages so
   319		 * later allocation can pick them up. Free them one by one even if
   320		 * they are larger in theory to ensure we don't double free.
   321		 */
 > 322	pr_info("XXX %s:%d page phys addr %lx\n", __func__, __LINE__, page_to_boot_pfn(page));
   323		if (!dma_release_from_contiguous(NULL, page, 1)) {
   324			for (i = 0; i < count; i++)
   325				ClearPageReserved(page + i);
   326			__free_pages(page, order);
   327	pr_info("XXX %s:%d normal page order %d\n", __func__, __LINE__, order);
   328		} else {
   329	pr_info("XXX %s:%d DMA page\n", __func__, __LINE__);
   330		}
   331	}
   332	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

