Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EEC26F572
	for <lists+kvm-ppc@lfdr.de>; Fri, 18 Sep 2020 07:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgIRFrE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 18 Sep 2020 01:47:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:10182 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIRFrE (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 18 Sep 2020 01:47:04 -0400
IronPort-SDR: MeE5VHltrb8SojEOH492E5WxEOaWkijNdxRHaYD66wTPx5Pp7D+uB1cJG+KN76Edkf1pXFYGuv
 ZrGbfS0V5TRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="160785977"
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="160785977"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 22:47:02 -0700
IronPort-SDR: 055zzU6FbRpCYKs4W6iIJ/OFlIFZiAPrRtOii5bXjMR8P78dPz9rhR+RhjtwwtDescrVc32Zmm
 jyvRNRNgj/sg==
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="484057199"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.3]) ([10.239.13.3])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 22:46:59 -0700
Subject: Re: [kbuild-all] Re:
 arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:633:12: error: no previous
 prototype for 'kvm_arch_post_init_vm'
To:     Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Junaid Shahid <junaids@google.com>
Cc:     kbuild-all@lists.01.org, linux-arm-kernel@lists.infradead.org,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
References: <202009111950.BkbYSqxt%lkp@intel.com>
 <8012684b-145a-3355-abdd-0cf281887b41@redhat.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <bbe0ea06-f967-a366-8711-8561e7b79a9d@intel.com>
Date:   Fri, 18 Sep 2020 13:46:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8012684b-145a-3355-abdd-0cf281887b41@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 9/12/20 2:52 PM, Paolo Bonzini wrote:
> On 11/09/20 13:43, kernel test robot wrote:
>>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:633:12: error: no previous prototype for 'kvm_arch_post_init_vm' [-Werror=missing-prototypes]
>>       633 | int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>>           |            ^~~~~~~~~~~~~~~~~~~~~
>>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:642:13: error: no previous prototype for 'kvm_arch_pre_destroy_vm' [-Werror=missing-prototypes]
>>       642 | void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>>           |             ^~~~~~~~~~~~~~~~~~~~~~~
>>     cc1: all warnings being treated as errors
> This makes little sense, the prototypes are in include/linux/kvm_host.h
> Also this code is not architecture-dependent...
>
> kvm-ppc guys, can you reproduce it?

Hi Paolo,

The error can be reproduced with W=1:

$ make W=1 
CROSS_COMPILE=/home/nfs/0day/gcc-9.3.0-nolibc/powerpc64-linux/bin/powerpc64-linux- 
ARCH=powerpc M=arch/powerpc/kvm | grep kvm_main
   CC [M]  arch/powerpc/kvm/../../../virt/kvm/kvm_main.o
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:633:12: warning: no 
previous prototype for 'kvm_arch_post_init_vm' [-Wmissing-prototypes]
   633 | int __weak kvm_arch_post_init_vm(struct kvm *kvm)
       |            ^~~~~~~~~~~~~~~~~~~~~
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:642:13: warning: no 
previous prototype for 'kvm_arch_pre_destroy_vm' [-Wmissing-prototypes]
   642 | void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
       |             ^~~~~~~~~~~~~~~~~~~~~~~

Best Regards,
Rong Chen

>
> Paolo
>
>>
>> Hi Junaid,
>>
>> FYI, the error/warning still remains.
>>
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> head:   e5bd0d2afe7061562c483d301e4aabb51b13fcfa
>> commit: 1aa9b9572b10529c2e64e2b8f44025d86e124308 kvm: x86: mmu: Recovery of shattered NX large pages
>> date:   10 months ago
>> config: powerpc-defconfig (attached as .config)
>> compiler: powerpc64-linux-gcc (GCC) 9.3.0
>> reproduce (this is a W=1 build):
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          git checkout 1aa9b9572b10529c2e64e2b8f44025d86e124308
>>          # save the attached .config to linux build tree
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=powerpc
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:633:12: error: no previous prototype for 'kvm_arch_post_init_vm' [-Werror=missing-prototypes]
>>       633 | int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>>           |            ^~~~~~~~~~~~~~~~~~~~~
>>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:642:13: error: no previous prototype for 'kvm_arch_pre_destroy_vm' [-Werror=missing-prototypes]
>>       642 | void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>>           |             ^~~~~~~~~~~~~~~~~~~~~~~
>>     cc1: all warnings being treated as errors
>>
>> # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1aa9b9572b10529c2e64e2b8f44025d86e124308
>> git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> git fetch --no-tags linus xlnx/master
>> git checkout 1aa9b9572b10529c2e64e2b8f44025d86e124308
>> vim +/kvm_arch_post_init_vm +633 arch/powerpc/kvm/../../../virt/kvm/kvm_main.c
>>
>>     628	
>>     629	/*
>>     630	 * Called after the VM is otherwise initialized, but just before adding it to
>>     631	 * the vm_list.
>>     632	 */
>>   > 633	int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>>     634	{
>>     635		return 0;
>>     636	}
>>     637	
>>     638	/*
>>     639	 * Called just after removing the VM from the vm_list, but before doing any
>>     640	 * other destruction.
>>     641	 */
>>   > 642	void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>>     643	{
>>     644	}
>>     645	
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>>
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

