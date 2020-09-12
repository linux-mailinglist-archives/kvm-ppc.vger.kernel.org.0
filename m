Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0D7267862
	for <lists+kvm-ppc@lfdr.de>; Sat, 12 Sep 2020 08:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgILGws (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 12 Sep 2020 02:52:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgILGwq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 12 Sep 2020 02:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599893565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRyQ1QFxCDQ8OqpfKXLD/GbTGE4WwcpE62BrSVEtBkw=;
        b=cghvapdKs5NiRB2wpzte6l6Ek5f8OXETwX6DBvZahKuHVbQvzi1/ZkJsZYc+dmLLxOzG70
        bXcA3nX4wSwaH0HbzaSy5aQR8gRvLX9oxh//AsxrVuUiSoc4lJQZBDg/rxc3D6dCZv6iyP
        2WEgoBTQm2SkiVp0MGYDZw9xhAPQMV4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-LXiuMWbFOsaw7JtBvY6OUw-1; Sat, 12 Sep 2020 02:52:19 -0400
X-MC-Unique: LXiuMWbFOsaw7JtBvY6OUw-1
Received: by mail-wm1-f69.google.com with SMTP id s24so2330456wmh.1
        for <kvm-ppc@vger.kernel.org>; Fri, 11 Sep 2020 23:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SRyQ1QFxCDQ8OqpfKXLD/GbTGE4WwcpE62BrSVEtBkw=;
        b=lJhzhI4JKr/EftyhKQlvGjS5BqCXi7wYqTUUXYqQTzZfkHsDD7XG0pi9pjUc5ZUXcd
         UvGm1UX8ZFVgrMdVJtUpqAKpCQpMcoReDn6loN0/Shhc19IIvNUeFlNSSGefurlkPV3y
         dcj7PDYtQ+1b3Y7vr4CvLvR4y420ZV0gFr4D9trYH9C3l3D6uREpoGEHYCd14IxidbN3
         MSK4rtGU02xC53rabVejaCiMd9SA8u6J3K6cRLLvGuIz3uw6N0cDEvWm0xkbO3SeNx2e
         RixJwXlwViVYz/CWcBvS5mbRuIsfKfaUFB8X7TCI7ljzR55bScRGuMSfUV6ghoH1WeyB
         kfOg==
X-Gm-Message-State: AOAM530ksnqFtJ3VptixH+yBn5/OAd6Kc01bRGpZNjs9jzwaRbeNPjyh
        ogRiqNbxEmXgnLwD8lhns23DqTJpwsoSGlWzeZb4W3EspO0ncaHt1GMrzKaeF6p5DYnynvthosP
        5jCpEUpvdQlzoUDroGA==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr5742207wrj.92.1599893537727;
        Fri, 11 Sep 2020 23:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGTbBg/jF29fakE1FZdqj99dDelahVRhx+p0vTf2b6aR808q04Prj08x/aA7jkcrhx01HIOA==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr5742182wrj.92.1599893537483;
        Fri, 11 Sep 2020 23:52:17 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id e18sm9601700wra.36.2020.09.11.23.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 23:52:16 -0700 (PDT)
Subject: Re: arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:633:12: error: no
 previous prototype for 'kvm_arch_post_init_vm'
To:     kernel test robot <lkp@intel.com>,
        Junaid Shahid <junaids@google.com>
Cc:     kbuild-all@lists.01.org, linux-arm-kernel@lists.infradead.org,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
References: <202009111950.BkbYSqxt%lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8012684b-145a-3355-abdd-0cf281887b41@redhat.com>
Date:   Sat, 12 Sep 2020 08:52:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <202009111950.BkbYSqxt%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 11/09/20 13:43, kernel test robot wrote:
>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:633:12: error: no previous prototype for 'kvm_arch_post_init_vm' [-Werror=missing-prototypes]
>      633 | int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>          |            ^~~~~~~~~~~~~~~~~~~~~
>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:642:13: error: no previous prototype for 'kvm_arch_pre_destroy_vm' [-Werror=missing-prototypes]
>      642 | void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>          |             ^~~~~~~~~~~~~~~~~~~~~~~
>    cc1: all warnings being treated as errors

This makes little sense, the prototypes are in include/linux/kvm_host.h
Also this code is not architecture-dependent...

kvm-ppc guys, can you reproduce it?

Paolo

> 
> 
> Hi Junaid,
> 
> FYI, the error/warning still remains.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   e5bd0d2afe7061562c483d301e4aabb51b13fcfa
> commit: 1aa9b9572b10529c2e64e2b8f44025d86e124308 kvm: x86: mmu: Recovery of shattered NX large pages
> date:   10 months ago
> config: powerpc-defconfig (attached as .config)
> compiler: powerpc64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 1aa9b9572b10529c2e64e2b8f44025d86e124308
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=powerpc 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:633:12: error: no previous prototype for 'kvm_arch_post_init_vm' [-Werror=missing-prototypes]
>      633 | int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>          |            ^~~~~~~~~~~~~~~~~~~~~
>>> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:642:13: error: no previous prototype for 'kvm_arch_pre_destroy_vm' [-Werror=missing-prototypes]
>      642 | void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>          |             ^~~~~~~~~~~~~~~~~~~~~~~
>    cc1: all warnings being treated as errors
> 
> # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1aa9b9572b10529c2e64e2b8f44025d86e124308
> git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> git fetch --no-tags linus xlnx/master
> git checkout 1aa9b9572b10529c2e64e2b8f44025d86e124308
> vim +/kvm_arch_post_init_vm +633 arch/powerpc/kvm/../../../virt/kvm/kvm_main.c
> 
>    628	
>    629	/*
>    630	 * Called after the VM is otherwise initialized, but just before adding it to
>    631	 * the vm_list.
>    632	 */
>  > 633	int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>    634	{
>    635		return 0;
>    636	}
>    637	
>    638	/*
>    639	 * Called just after removing the VM from the vm_list, but before doing any
>    640	 * other destruction.
>    641	 */
>  > 642	void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>    643	{
>    644	}
>    645	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

