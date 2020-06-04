Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE17D1EEAB7
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Jun 2020 20:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgFDS6M (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Jun 2020 14:58:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29979 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728476AbgFDS6M (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Jun 2020 14:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591297090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltc7AAOMOPUPkUttvlRhefl/zKjkU15T+NRuGo1EozI=;
        b=AFPXnvtE6pegC5hFenIzgFjxHysipNz6D26fPI3UOX5zhEA5peqdraZwqvQJOJJhk+Qp4F
        w1LY856EuVW0XcDCv9yksJovZzk+0UbFW4RLAJVx/GTab1GsQdr5QjSiqd+g67ojzc8/sR
        EkTUfZD6pDqMSpYJfIiv9Vrsf2jTeR8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-a5CLpbHUMNymQKxdZB0vjw-1; Thu, 04 Jun 2020 14:58:08 -0400
X-MC-Unique: a5CLpbHUMNymQKxdZB0vjw-1
Received: by mail-wr1-f69.google.com with SMTP id w16so2772366wru.18
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Jun 2020 11:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ltc7AAOMOPUPkUttvlRhefl/zKjkU15T+NRuGo1EozI=;
        b=r5yInTQF/7zkztC8Lq38y71M6/Op7On3aGi1AH0SAVO77KCVHvd2cQfTkjdoZQaNAQ
         Qp/NMgWFubiOSCmqR9IFUiZFnlxP1ldhvs8p2zo9sQBneLX2CZQe6cmHuHAVIDMgpV9u
         2OW5CMfsT8WsdswDQwPgjk8cGP4TMNd2r+/o4kdjzqYR0Q8CANZQ2IpZozR9th8nKULa
         70DMA2mTwfF346oyrur5KtNVwkMR8JNphrGZFi0lfw44mh+Md+/CNKMsCYCE+OtS2SxS
         yHUzLmy/+9WYldWevLCYyzmuVfD566F4CUKXmbnAFbSZ+NnL84BImqxJo8RaW1iDeIuw
         vXnA==
X-Gm-Message-State: AOAM531rB4fioR7uwp/ld1kKT1JMw7dxlzz+GBkhHq8x3qINyp7nUFUm
        3CZaBzXTNSup+Bl97dZsZeHVm6yesp9CIrS1sHlU1gdzl4GtlSxf1sBnUmv9Pdp7SF4156BiDGV
        eK82Nu1KZMbTKvuCccA==
X-Received: by 2002:adf:ef83:: with SMTP id d3mr5430080wro.145.1591297087322;
        Thu, 04 Jun 2020 11:58:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6Mh2tZEK9h1YhyPsdCcQG+RuzgRYNiaLHzFsWDjE7ghjh9VxuCSIkvZCInTNo/mgS+4OFpQ==
X-Received: by 2002:adf:ef83:: with SMTP id d3mr5430071wro.145.1591297087081;
        Thu, 04 Jun 2020 11:58:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id u7sm9235367wrm.23.2020.06.04.11.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 11:58:06 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.8-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
References: <20200601235357.GB428673@thinks.paulus.ozlabs.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87d0e310-8714-0104-90ef-d4f82920f502@redhat.com>
Date:   Thu, 4 Jun 2020 20:58:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200601235357.GB428673@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 02/06/20 01:53, Paul Mackerras wrote:
> Hi Paolo,
> 
> Please do a pull from my kvm-ppc-next-5.8-1 tag to get a PPC KVM
> update for 5.8.  It's a relatively small update this time.  Michael
> Ellerman also has some commits in his tree that touch
> arch/powerpc/kvm, but I have not merged them here because there are no
> merge conflicts, and so they can go to Linus via Michael's tree.
> 
> Thanks,
> Paul.
> 
> The following changes since commit 9d5272f5e36155bcead69417fd12e98624e7faef:
> 
>   Merge tag 'noinstr-x86-kvm-2020-05-16' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into HEAD (2020-05-20 03:40:09 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.8-1
> 
> for you to fetch changes up to 11362b1befeadaae4d159a8cddcdaf6b8afe08f9:
> 
>   KVM: PPC: Book3S HV: Close race with page faults around memslot flushes (2020-05-28 10:56:42 +1000)
> 
> ----------------------------------------------------------------
> PPC KVM update for 5.8
> 
> - Updates and bug fixes for secure guest support
> - Other minor bug fixes and cleanups.
> 
> ----------------------------------------------------------------
> Chen Zhou (1):
>       KVM: PPC: Book3S HV: Remove redundant NULL check
> 
> Laurent Dufour (2):
>       KVM: PPC: Book3S HV: Read ibm,secure-memory nodes
>       KVM: PPC: Book3S HV: Relax check on H_SVM_INIT_ABORT
> 
> Paul Mackerras (2):
>       KVM: PPC: Book3S HV: Remove user-triggerable WARN_ON
>       KVM: PPC: Book3S HV: Close race with page faults around memslot flushes
> 
> Qian Cai (2):
>       KVM: PPC: Book3S HV: Ignore kmemleak false positives
>       KVM: PPC: Book3S: Fix some RCU-list locks
> 
> Tianjia Zhang (2):
>       KVM: PPC: Remove redundant kvm_run from vcpu_arch
>       KVM: PPC: Clean up redundant 'kvm_run' parameters
> 
>  arch/powerpc/include/asm/kvm_book3s.h    | 16 +++----
>  arch/powerpc/include/asm/kvm_host.h      |  1 -
>  arch/powerpc/include/asm/kvm_ppc.h       | 27 ++++++------
>  arch/powerpc/kvm/book3s.c                |  4 +-
>  arch/powerpc/kvm/book3s.h                |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c      | 12 ++---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c   | 36 +++++++++++----
>  arch/powerpc/kvm/book3s_64_vio.c         | 18 ++++++--
>  arch/powerpc/kvm/book3s_emulate.c        | 10 ++---
>  arch/powerpc/kvm/book3s_hv.c             | 75 +++++++++++++++++---------------
>  arch/powerpc/kvm/book3s_hv_nested.c      | 15 +++----
>  arch/powerpc/kvm/book3s_hv_uvmem.c       | 14 ++++++
>  arch/powerpc/kvm/book3s_paired_singles.c | 72 +++++++++++++++---------------
>  arch/powerpc/kvm/book3s_pr.c             | 30 ++++++-------
>  arch/powerpc/kvm/booke.c                 | 36 +++++++--------
>  arch/powerpc/kvm/booke.h                 |  8 +---
>  arch/powerpc/kvm/booke_emulate.c         |  2 +-
>  arch/powerpc/kvm/e500_emulate.c          | 15 +++----
>  arch/powerpc/kvm/emulate.c               | 10 ++---
>  arch/powerpc/kvm/emulate_loadstore.c     | 32 +++++++-------
>  arch/powerpc/kvm/powerpc.c               | 72 +++++++++++++++---------------
>  arch/powerpc/kvm/trace_hv.h              |  6 +--
>  22 files changed, 276 insertions(+), 237 deletions(-)
> 

Pulled, thanks.

Paolo

