Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22971998DF
	for <lists+kvm-ppc@lfdr.de>; Tue, 31 Mar 2020 16:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgCaOrl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 31 Mar 2020 10:47:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39020 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726595AbgCaOrk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 31 Mar 2020 10:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585666059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fD56lo2CzF0TkcUSB2i8bItoMn26OtVWGRYz4s2D9Zw=;
        b=ASMj3fCjCoHEaQRbyNIzmzg4xIfMoC9vtZg5F4IztZHfvsXpeenS9xVY1NRVXH+s26JtD8
        CH4l4bNFx7Wmm/zjLw+UPRONcNl/AQ9lpOc+9j5tFzIQlbaQoVR3RIUaa+n89BMHcH01yU
        BJnBAPiQ4IVRV8C6t5YadXQArF1YLqE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-2P-DOOrpMum6xkZau00Eyg-1; Tue, 31 Mar 2020 10:47:37 -0400
X-MC-Unique: 2P-DOOrpMum6xkZau00Eyg-1
Received: by mail-wr1-f69.google.com with SMTP id e10so13166538wrm.2
        for <kvm-ppc@vger.kernel.org>; Tue, 31 Mar 2020 07:47:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fD56lo2CzF0TkcUSB2i8bItoMn26OtVWGRYz4s2D9Zw=;
        b=msn4JTX68vSTZwRQBuBYLr8nhYFjSWFgwLXST4ie2KVyTNz2Sp8pme0rCcgH0Q8kKO
         fbCvqveVX9SvXWui/MrxeIoSBODi4GcvaQRVigB6nJAJyS8oUB4gvltLqzAtcf603t8X
         90J6AfH3RFx4gmb7RlgRrV3hyavuez02zN3Rll6GOIAKU09jFv4f5cHSygJih6lJOmxX
         vCorb8ldXHdJZoWMpHnP4fKkAQqjxpAMiCc8DLZ+RK6to02Ohh8Z5gcVFX2K5lkgTULx
         /CaU8xfW2Wj8Kq86gPPZlx6e4CpF/qzy6HOeNf6p4oNSrOwU4x/GQWtwIT5YQN5MI55W
         XPng==
X-Gm-Message-State: ANhLgQ1AZzCH9v8vgljmkTsCd1ZTmUGqxdW0GfEBTdYSc7JY7RLayB6F
        8Xf3w6NlrBZsbiPmaYtcBdOY8L+JKwEJMq49/DFNKJQMgnaoTuA+FUrZNa4P8fKK9b4z9SRLgDG
        EFtJANQHwsOK30y+HXw==
X-Received: by 2002:a1c:9e16:: with SMTP id h22mr3760986wme.27.1585666055991;
        Tue, 31 Mar 2020 07:47:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vv9UKQUyXBr2DyVJYnG+A1F4So9WE1o1E54eRR7FTTx5VsorxPuZbhF0pf6Moq2P1XJv5vwRA==
X-Received: by 2002:a1c:9e16:: with SMTP id h22mr3760962wme.27.1585666055727;
        Tue, 31 Mar 2020 07:47:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id c18sm27178480wrx.5.2020.03.31.07.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 07:47:35 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.7-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20200330230802.GB27514@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a3f4815a-29f2-527e-208d-9196a2db15d8@redhat.com>
Date:   Tue, 31 Mar 2020 16:47:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200330230802.GB27514@blackberry>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 31/03/20 01:08, Paul Mackerras wrote:
> Paolo,
> 
> Please do a pull from my kvm-ppc-next-5.7-1 tag to get a PPC KVM
> update for 5.7.
> 
> Thanks,
> Paul.
> 
> The following changes since commit 1c482452d5db0f52e4e8eed95bd7314eec537d78:
> 
>   Merge tag 'kvm-s390-next-5.7-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2020-03-16 18:19:34 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.7-1
> 
> for you to fetch changes up to 9a5788c615f52f6d7bf0b61986a632d4ec86791d:
> 
>   KVM: PPC: Book3S HV: Add a capability for enabling secure guests (2020-03-26 11:09:04 +1100)
> 
> ----------------------------------------------------------------
> KVM PPC update for 5.7
> 
> * Add a capability for enabling secure guests under the Protected
>   Execution Framework ultravisor
> 
> * Various bug fixes and cleanups.
> 
> ----------------------------------------------------------------
> Fabiano Rosas (1):
>       KVM: PPC: Book3S HV: Skip kvmppc_uvmem_free if Ultravisor is not supported
> 
> Greg Kurz (3):
>       KVM: PPC: Book3S PR: Fix kernel crash with PR KVM
>       KVM: PPC: Book3S PR: Move kvmppc_mmu_init() into PR KVM
>       KVM: PPC: Kill kvmppc_ops::mmu_destroy() and kvmppc_mmu_destroy()
> 
> Gustavo Romero (1):
>       KVM: PPC: Book3S HV: Treat TM-related invalid form instructions on P9 like the valid ones
> 
> Joe Perches (1):
>       KVM: PPC: Use fallthrough;
> 
> Laurent Dufour (2):
>       KVM: PPC: Book3S HV: Check caller of H_SVM_* Hcalls
>       KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN
> 
> Michael Ellerman (1):
>       KVM: PPC: Book3S HV: Use RADIX_PTE_INDEX_SIZE in Radix MMU code
> 
> Michael Roth (1):
>       KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests
> 
> Paul Mackerras (2):
>       KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT page fault handler
>       KVM: PPC: Book3S HV: Add a capability for enabling secure guests
> 
>  Documentation/virt/kvm/api.rst              |  17 ++++
>  arch/powerpc/include/asm/kvm_asm.h          |   3 +
>  arch/powerpc/include/asm/kvm_book3s_uvmem.h |   6 ++
>  arch/powerpc/include/asm/kvm_host.h         |   1 +
>  arch/powerpc/include/asm/kvm_ppc.h          |   4 +-
>  arch/powerpc/kvm/book3s.c                   |   5 --
>  arch/powerpc/kvm/book3s.h                   |   1 +
>  arch/powerpc/kvm/book3s_32_mmu.c            |   2 +-
>  arch/powerpc/kvm/book3s_32_mmu_host.c       |   2 +-
>  arch/powerpc/kvm/book3s_64_mmu.c            |   2 +-
>  arch/powerpc/kvm/book3s_64_mmu_host.c       |   2 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c         | 119 +++++++++++++---------------
>  arch/powerpc/kvm/book3s_64_mmu_radix.c      |   2 +-
>  arch/powerpc/kvm/book3s_hv.c                |  55 +++++++++----
>  arch/powerpc/kvm/book3s_hv_tm.c             |  28 +++++--
>  arch/powerpc/kvm/book3s_hv_tm_builtin.c     |  16 +++-
>  arch/powerpc/kvm/book3s_hv_uvmem.c          |  19 ++++-
>  arch/powerpc/kvm/book3s_pr.c                |   6 +-
>  arch/powerpc/kvm/booke.c                    |  11 +--
>  arch/powerpc/kvm/booke.h                    |   2 -
>  arch/powerpc/kvm/e500.c                     |   1 -
>  arch/powerpc/kvm/e500_mmu.c                 |   4 -
>  arch/powerpc/kvm/e500mc.c                   |   1 -
>  arch/powerpc/kvm/powerpc.c                  |  17 +++-
>  include/uapi/linux/kvm.h                    |   1 +
>  25 files changed, 205 insertions(+), 122 deletions(-)
> 

Pulled, thanks.

Paolo

