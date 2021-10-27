Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523EC43CDC1
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Oct 2021 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242803AbhJ0Pk0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Oct 2021 11:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238780AbhJ0PkZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Oct 2021 11:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635349080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bSqxXsSY7PzPPy6E5Cy05Nx/OdmHcN1STcnBEYyHdIs=;
        b=MbMxbXAupMhsOj7n1ORnzGUbt2FJk9mfhs1WY97br91xQhy2gI1grOuvQnxEp6LE0pzRZZ
        1ueNqOMlSarkjIx3XpEKw+UEb5n1ek2asuexqFwukbmOUCbHmkd+mobwHsmwa1bWXKCwn1
        2CRz2Zv9n8TOyxe7u0sslDWf0CgTm/E=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-lPNnvxmsOMWnJr-FYq0MCg-1; Wed, 27 Oct 2021 11:37:58 -0400
X-MC-Unique: lPNnvxmsOMWnJr-FYq0MCg-1
Received: by mail-ed1-f72.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so2656304edj.21
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 08:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bSqxXsSY7PzPPy6E5Cy05Nx/OdmHcN1STcnBEYyHdIs=;
        b=adNsGdoqhZRTrz5XbphZiqOXOJFEXSXpMAhCkDb08jIzOtenoAT/Va2eKoWnENTIS/
         tuwTEPM0mlSgH/YF8dcRj2DZsQS7gZxtfzWotxivCZPK6kb+gH4upcVRNTgs1/IFWX5k
         16Yl4vphT9vpnLVCayaJQMuU4z6+qniQXtxGaYPmLdjPKgoTaFt0HavaIeDzi3ng1Ob7
         r2YF+gKwmL1QzDaVY4ZdgPP3bWnR+ZjmecCqahKt3HS5Wuxila4RL/N122HXb3oCBBsC
         h0TwUgYp/FXebsc1PzLgawTz5cg3ngUFoLk8+WJUalSEHQGbshGWMKLu9GavfNSOq9wQ
         5Prg==
X-Gm-Message-State: AOAM5313VDG0lSS7noHIqrclmbCKDjjm0anVlLHaKu3c2vDxQUtoc2nd
        qQPGp4MRBkeZPBOAii/7kQ4TkWQ4Sz9BHfsyTCs5/LiX68+wyplXgWfXhpg9EbuPHo0ITbWL3RJ
        MQVG2eIoSqrslu2h4BA==
X-Received: by 2002:a05:6402:520f:: with SMTP id s15mr19650581edd.376.1635349077543;
        Wed, 27 Oct 2021 08:37:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcV3ajcrSuCCBMr6jO83QbO8KNKYMvLx5Z90JLfoEGGYsQl7acheIlREFbLHWM9uSofWHX3A==
X-Received: by 2002:a05:6402:520f:: with SMTP id s15mr19650552edd.376.1635349077353;
        Wed, 27 Oct 2021 08:37:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h7sm218074edt.37.2021.10.27.08.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:37:56 -0700 (PDT)
Message-ID: <5b8f554b-5bbc-e257-12d0-800ec82489d0@redhat.com>
Date:   Wed, 27 Oct 2021 17:37:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
 <YXllGfrjPX1pVUx6@google.com>
 <ecec4d7d-13dd-c992-6648-3624d7c14c24@redhat.com>
 <YXlwH2vWILFS9QOG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXlwH2vWILFS9QOG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 27/10/21 17:28, Sean Christopherson wrote:
> On Wed, Oct 27, 2021, Paolo Bonzini wrote:
>> On 27/10/21 16:41, Sean Christopherson wrote:
>>> The other thing I don't like about having the WARN in the loop is that it suggests
>>> that something other than the vCPU can modify the NDST and SN fields, which is
>>> wrong and confusing (for me).
>>
>> Yeah, I can agree with that.  Can you add it in a comment above the cmpxchg
>> loop, it can be as simple as
>>
>> 	/* The processor can set ON concurrently.  */
>>
>> when you respin patch 21 and the rest of the series?
> 
> I can definitely add a comment, but I think that comment is incorrect.

It's completely backwards indeed.  I first had "the hardware" and then 
shut down my brain for a second to replace it.

> So something like this?
> 
> 	/* ON can be set concurrently by a different vCPU or by hardware. */

Yes, of course.

Paolo

