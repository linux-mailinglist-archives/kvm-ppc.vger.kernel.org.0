Return-Path: <kvm-ppc+bounces-100-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 294628BBD7D
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 19:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D39E728238B
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 17:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843A15A117;
	Sat,  4 May 2024 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a1W8XI+M"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3651EF12
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714844384; cv=none; b=t+nBvaSoFLO3F6Qva8LZnpghnrBYpKeH9HGpBvvGae6ekas8JUK6J+7Gn6VMaSDeUtS4oz8+3f/zYkDxNThlevDe0SeAddLhRA9u/rGR6nGf4AWDyo3s5Z4clowLNq1Y6/yx7t0bCq5Va++zK9+S+8YOFPSJLAuFofr3O929Dfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714844384; c=relaxed/simple;
	bh=TPIhprZVWbSRVXAOTw8nl9otuMpeEhWcEFWLXHNhFh8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ohyt05MjWEn9hHWihjxCVRq1UwrBb/dqs2Zjf7AxMi1jW7it8Ocifdi/beyTKuQaz6iSm5h3Jvu0a3vwJFdmM/Fl5IKjFXGI2heKlymzEixzfT7XAtqERwxPHbiaiKszJ+UqhRjOKy8Ri2mMENmb/bFWjrh3sQMzJ5skUkY38I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a1W8XI+M; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714844383; x=1746380383;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=TPIhprZVWbSRVXAOTw8nl9otuMpeEhWcEFWLXHNhFh8=;
  b=a1W8XI+MNBaPhNEL9066LnUyHSUNwdafqWVaGOaYnuRZLw8CM1VeQLQS
   N0Gi4gB0YFzA5IM+yd2Qky/h6bAvr2nZYDlNDnGLyODBOU2uV/ZQj9I76
   0moRcnKfIN0pLf7EDcnkpsq9pKi6P7eNKh8qnk7bZRT2JQlu7HhwIrwfd
   HqBdQvU2KCEieiHWZNz5agmT0L1DbnJeT6UvQa9lCUs/9CT3vKH4H+jPH
   UPSou8cjSl0VIjQndXmc/RU9EmLcZPH9Vj8sqbNq5J1d+oGHM5376ienK
   H2XaN4MLGdEfUfBFbD4WtSVqVWJT1ZNJHyNXb+7wvR4BK5dXrxB5uXcIv
   Q==;
X-CSE-ConnectionGUID: JOCxrQi3Rxm+5IUTRDVtOQ==
X-CSE-MsgGUID: Hl0zLNDzSPmuFKK18oHWRw==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="14443674"
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="14443674"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 10:39:42 -0700
X-CSE-ConnectionGUID: VfcbRssbRiau464FIVXvPA==
X-CSE-MsgGUID: okyjVDaJS5qGvyHdY90Ghw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="32254925"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 04 May 2024 10:39:41 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3JMJ-000D1U-0e;
	Sat, 04 May 2024 17:39:39 +0000
Date: Sun, 5 May 2024 01:38:46 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 5/27] include/linux/kexec.h:537:42:
 warning: 'struct kimage' declared inside parameter list will not be visible
 outside of this definition or declaration
Message-ID: <202405050137.SroddioA-lkp@intel.com>
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
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20240505/202405050137.SroddioA-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050137.SroddioA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050137.SroddioA-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from kernel/panic.c:25:
>> include/linux/kexec.h:537:42: warning: 'struct kimage' declared inside parameter list will not be visible outside of this definition or declaration
     537 | static inline int kho_fill_kimage(struct kimage *image) { return 0; }
         |                                          ^~~~~~


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

