Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9511D52545E
	for <lists+kvm-ppc@lfdr.de>; Thu, 12 May 2022 20:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357489AbiELSBN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 12 May 2022 14:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiELSAu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 12 May 2022 14:00:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C54964D8
        for <kvm-ppc@vger.kernel.org>; Thu, 12 May 2022 11:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652378448; x=1683914448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PD1Io4Wa6C0Ag10n1oVD9y2Eh6h8qkoqTzY1mJg6nzE=;
  b=guq3Xi+dvv4u40CPGxq10Tdo00Da4MjLfqd+0xoJYxQ+ZL2//6gm5y9w
   RZmCXFhVoLW8TPkNQxO8gje7sNg2InBhaQTdNsT9f07zI4E9BpOBCnxJ7
   rv/Wpf+g0zvV4AhwwzLlmtmI1BJ3R4vhQlcy2fb7fdbxtwIK8KxNU619w
   wI9vOtHH/jL+GrlVbdhdow5SiZjPNMq3W5JpQdrjfAP2eA7unAW7kOBbU
   YxiLxR/5sE2NNm/JYm+KVaHaXSVA/29qs2PrwLH3hS5FXakgYa0yA3ZG4
   F4AOfNdzDY+nBOpZhHF/R4IvOhTiYhj84DoC0WRmIXteuSlGUbtq1Quds
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="249996660"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="249996660"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 11:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="566820996"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 12 May 2022 11:00:43 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1npD7D-000Kmd-3P;
        Thu, 12 May 2022 18:00:43 +0000
Date:   Fri, 13 May 2022 01:59:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kbuild-all@lists.01.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH kernel] KVM: PPC: Book3s: Remove real mode interrupt
 controller hcalls handlers
Message-ID: <202205130131.pJEWLeCR-lkp@intel.com>
References: <20220509071150.181250-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509071150.181250-1-aik@ozlabs.ru>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Alexey,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on powerpc/topic/ppc-kvm]
[also build test ERROR on v5.18-rc6 next-20220512]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexey-Kardashevskiy/KVM-PPC-Book3s-Remove-real-mode-interrupt-controller-hcalls-handlers/20220509-151356
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
config: powerpc64-defconfig (https://download.01.org/0day-ci/archive/20220513/202205130131.pJEWLeCR-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5689429d96c7921451769fa24e3d037147c7da11
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexey-Kardashevskiy/KVM-PPC-Book3s-Remove-real-mode-interrupt-controller-hcalls-handlers/20220509-151356
        git checkout 5689429d96c7921451769fa24e3d037147c7da11
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash arch/powerpc/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/powerpc/kvm/book3s_hv_rm_xics.c:482:15: error: no previous prototype for 'xics_rm_h_xirr_x' [-Werror=missing-prototypes]
     482 | unsigned long xics_rm_h_xirr_x(struct kvm_vcpu *vcpu)
         |               ^~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors


vim +/xics_rm_h_xirr_x +482 arch/powerpc/kvm/book3s_hv_rm_xics.c

   481	
 > 482	unsigned long xics_rm_h_xirr_x(struct kvm_vcpu *vcpu)
   483	{
   484		vcpu->arch.regs.gpr[5] = get_tb();
   485		return xics_rm_h_xirr(vcpu);
   486	}
   487	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
