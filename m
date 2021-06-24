Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D06F3B2C54
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 12:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhFXKX1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 06:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232063AbhFXKX0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 06:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624530067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oKXkBJKG47HF5zZ+T34yALxUp2DCGSnnk7HiRaaGJBk=;
        b=OyOYIhkFlD72RXa4ApycBznJ8h/A4rxQkZYFz4zqo5MtkH1geetKyPWMfBX0ch0jh7q3Lg
        qnz7zGgvlyQUIzPbypEimxNaD0+gpIcj0/R+UxQuP9AGOacLVchr1yQsGXdxC66zyvRmgz
        DHDojJLPq7Dlhzp9U4RjDK0rp/NxRo4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-rwGFZvNTMCaenngGBUcsDA-1; Thu, 24 Jun 2021 06:21:05 -0400
X-MC-Unique: rwGFZvNTMCaenngGBUcsDA-1
Received: by mail-ed1-f70.google.com with SMTP id v12-20020aa7dbcc0000b029038fc8e57037so3114030edt.0
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Jun 2021 03:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oKXkBJKG47HF5zZ+T34yALxUp2DCGSnnk7HiRaaGJBk=;
        b=FroJW3F0zqT0bcOzK880xvh4sFDUEAwPK5Jlz6ZzophNH8hvoAbFQ113ckHYjIWEx3
         Y4oY5vJDPy6JoNfGAbcELEjWqT+DoQ14Er//e47KX+Lx0hd0V4MZYA6cMYhDSxaa1IxX
         VSuPxkkELiwqjpj9YssWEuR1xppN41wCE78nKdeuVihFfpQ4dRnuzR/Ydo0nR3dh0qvS
         MpamTD7nL7++E9+M+WHqe+uo0pEEEgpWOJRTY/gayGESzW80jp7GXHTBMb/cBDkNgmuj
         7RotNnpDl351YJ7o7yShmCKmBjOeTwaCfpVPum1EPLXDF0G45cCCcTIiGZsJLTjGzyM6
         PtUA==
X-Gm-Message-State: AOAM530hg96j/LxI6jsWqCW/0Oq4GaFiwZQNFT/bt+/4CCvWkAmrWt/3
        VTEnza5NsZmwbyL5O8fbPSvCFanaXi8UJtmueypiWysfxXfLf+fVSDcNjGFrYklAJ0pkkJYP0lY
        acZyEbG1NclOuzo5JFA==
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr6001638edb.214.1624530064585;
        Thu, 24 Jun 2021 03:21:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs51nnE9ArY9tBUvtcT3K4P6rQ2AL9pfX67ccTlvEZ5+BaJldlaSdGdhR+tmPYnfTJgtakmA==
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr6001609edb.214.1624530064420;
        Thu, 24 Jun 2021 03:21:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e7sm493571ejm.93.2021.06.24.03.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 03:21:03 -0700 (PDT)
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To:     Nicholas Piggin <npiggin@gmail.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-3-stevensd@google.com>
 <1624524331.zsin3qejl9.astroid@bobo.none>
 <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
 <1624528342.s2ezcyp90x.astroid@bobo.none>
 <1624529635.75a1ann91v.astroid@bobo.none>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc2a88ed-6a98-857d-bb1f-73260b01ac30@redhat.com>
Date:   Thu, 24 Jun 2021 12:21:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624529635.75a1ann91v.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 24/06/21 12:17, Nicholas Piggin wrote:
>> If all callers were updated that is one thing, but from the changelog
>> it sounds like that would not happen and there would be some gfn_to_pfn
>> users left over.
>>
>> But yes in the end you would either need to make gfn_to_pfn never return
>> a page found via follow_pte, or change all callers to the new way. If
>> the plan is for the latter then I guess that's fine.
>
> Actually in that case anyway I don't see the need -- the existence of
> gfn_to_pfn is enough to know it might be buggy. It can just as easily
> be grepped for as kvm_pfn_page_unwrap.

Sure, but that would leave us with longer function names 
(gfn_to_pfn_page* instead of gfn_to_pfn*).  So the "safe" use is the one 
that looks worse and the unsafe use is the one that looks safe.

> And are gfn_to_page cases also
> vulernable to the same issue?

No, they're just broken for the VM_IO|VM_PFNMAP case.

Paolo

> So I think it could be marked deprecated or something if not everything
> will be converted in the one series, and don't need to touch all that
> arch code with this patch.

