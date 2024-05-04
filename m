Return-Path: <kvm-ppc+bounces-110-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5448BBDF3
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 22:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0403B21518
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 May 2024 20:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D607318A;
	Sat,  4 May 2024 20:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCTCoVIJ"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB04482485
	for <kvm-ppc@vger.kernel.org>; Sat,  4 May 2024 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714852850; cv=none; b=TtjLcP0+KxzCyQpR1LaGgmOGR5MQQebFNSZk52PyudDSLkO9T3UAA+92ay1ySGxfnyzTXecQ3MghUDBEQGRfUZDIaT4rgkF1Swzya0DxcKrNcODIHkY7X03U+iJkNs8rHHhDlvBoRUF+SkpN802BXWsHL+krcYcsoJ0Q3AL7T28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714852850; c=relaxed/simple;
	bh=i1TA1xp2etN08w3JdtDYisB5vD0j8agHbXlWgWTe1Qo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bl9Hc9kUyDDZeqD9q27oTaVnagIOfqmcGsQLDYwdAQ/z4aDhCR2SB61/capweuPeRi1M7q+ur1NsAr5wYcsOuqkWx93i/Rh3mdMFJiqyHpWuLFozzcfZ/3SsxoJeYVM4G5YAnEAdH8gD99YS9pMbyV4kFFlSIsAaw4xaPpKQayE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KCTCoVIJ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714852849; x=1746388849;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=i1TA1xp2etN08w3JdtDYisB5vD0j8agHbXlWgWTe1Qo=;
  b=KCTCoVIJTHaATxO6vPFgsPgqJCtMIr4C/BsGPgnDnAMZPoRni8RGy53c
   zrjQL81cb736Zm3tzuCjimkYO5H1KYoM1mXt0D5fED6kezXWc7rt4MD0Y
   pqSlMrBPqaIKIISrdVkqJ8Ai63PNJECHEaDh0qIBMWD8FWqOzdWoka+oO
   0nF8aKzW+/6Qq/onrGGpZNvyCoJ/VZBKWOzw+zvtnVYWMnOrCqUlQVHmF
   CPEFuyGJpMcEz0Gr7bzhrIMRx1TBql/gDQwvPq5UX0MenFdxu+r+TsajZ
   EPZRcmLVv+XLOPJcdM2T5nB8XUtwCoFGZ0ft+JP+3Vb4n/lVfEMnD1L8X
   g==;
X-CSE-ConnectionGUID: QPLhVOH/R6e8fwWTwNApdA==
X-CSE-MsgGUID: bagInVouRK6y1fg8/N+j/g==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="14447270"
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="14447270"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 13:00:48 -0700
X-CSE-ConnectionGUID: Yo5Iudx+SfezDb7ykv3uMg==
X-CSE-MsgGUID: CS1hSfNqRxWFcFq1WSDmzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,254,1708416000"; 
   d="scan'208";a="32570265"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 04 May 2024 13:00:47 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s3LYq-000D8i-2S;
	Sat, 04 May 2024 20:00:44 +0000
Date: Sun, 5 May 2024 03:59:47 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm-ppc@vger.kernel.org
Subject: [agraf-2.6:kvm-kho-gmem-test 24/27] drivers/misc/fdbox.c:504:47:
 warning: initialization discards 'const' qualifier from pointer target type
Message-ID: <202405050305.G2gWY32o-lkp@intel.com>
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
commit: eac026594b9dc0e92a0093a3443b9bc973be99a4 [24/27] XXX WIP
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20240505/202405050305.G2gWY32o-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050305.G2gWY32o-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405050305.G2gWY32o-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/misc/fdbox.c: In function 'fdbox_kho_recover':
>> drivers/misc/fdbox.c:504:47: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     504 |                                 ulong *link = fdt_getprop(fdt, fd, "link", &l);
         |                                               ^~~~~~~~~~~


vim +/const +504 drivers/misc/fdbox.c

   448	
   449	static void fdbox_kho_recover(void)
   450	{
   451		const void *fdt = kho_get_fdt();
   452		const char *path = "/fdbox";
   453		int fdbox, box, fd;
   454		int err;
   455	
   456		/* Not a KHO boot */
   457		if (!fdt)
   458			return;
   459	
   460		fdbox = fdt_path_offset(fdt, path);
   461		if (fdbox < 0) {
   462			pr_debug("Could not find '%s' in DT", path);
   463			return;
   464		}
   465	
   466		err = fdt_node_check_compatible(fdt, fdbox, "fdbox-v1");
   467		if (err) {
   468			char p[256] = "";
   469			fdt_get_path(fdt, fdbox, p, sizeof(p) - 1);
   470			pr_warn("Node '%s' has invalid compatible", p);
   471			return;
   472		}
   473	
   474		fdt_for_each_subnode(box, fdt, fdbox) {
   475			struct fdbox_create_box create_box = {
   476				.flags = 0,
   477			};
   478			struct box *new_box;
   479	
   480			strncpy(create_box.name, fdt_get_name(fdt, box, NULL), sizeof(create_box.name) - 1);
   481	
   482			err = fdt_node_check_compatible(fdt, box, "fdbox,box-v1");
   483			if (err) {
   484				char p[256] = "";
   485				fdt_get_path(fdt, box, p, sizeof(p) - 1);
   486				pr_warn("Node '%s' has invalid compatible", p);
   487				continue;
   488			}
   489	
   490			err = _fdbox_create_box(&create_box, &new_box);
   491			if (err) {
   492				char p[256] = "";
   493				fdt_get_path(fdt, box, p, sizeof(p) - 1);
   494				pr_warn("Node '%s' could not spawn", p);
   495				continue;
   496			}
   497	
   498			new_box->wrapped = true;
   499			
   500			fdt_for_each_subnode(fd, fdt, box) {
   501				if (!fdt_node_check_compatible(fdt, fd, "fdbox,fd-v1")) {
   502					int l;
   503					struct box_dangle *dangle;
 > 504					ulong *link = fdt_getprop(fdt, fd, "link", &l);
   505					struct fdbox_fd put_fd = {
   506						.flags = 0,
   507						.fd = -1,
   508					};
   509					struct box_fd *box_fd;
   510	
   511					strncpy(put_fd.name, fdt_get_name(fdt, fd, NULL), sizeof(put_fd.name) - 1);
   512	
   513					if (!link || l != sizeof(ulong))
   514						continue;
   515					dangle = find_dangle(*link);
   516					box_fd = fdbox_put_file(new_box, &put_fd, dangle->file);
   517					if (!box_fd)
   518						continue;
   519					list_del(&dangle->next);
   520				} else {
   521					char p[256] = "";
   522					fdt_get_path(fdt, fd, p, sizeof(p) - 1);
   523					pr_warn("Node '%s' has invalid compatible", p);
   524				}
   525			}
   526		}
   527	}
   528	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

