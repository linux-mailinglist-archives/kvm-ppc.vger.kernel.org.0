Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB34143B6A3
	for <lists+kvm-ppc@lfdr.de>; Tue, 26 Oct 2021 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbhJZQOq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 26 Oct 2021 12:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235993AbhJZQOp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 26 Oct 2021 12:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635264741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y/8qPSuga2nSdD4ObnPRjMzoPwBrPBTCysCx0s1aic4=;
        b=HXeh27CV8hJRaETDK6hQOpnP45k3CVN3SmEZGClNq7UYeHDti1sMQE40Q9KP2PP6tyaQ2I
        orJVQXxUk8U1XN2n6u+a3epp9C/dCkhT5MuzOp8x/Js6W5Za41+LrdIs+yGwZJjYq0362v
        79f1/BmEa6EFyJMmnSf2RTCKnOJQnls=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-n0zpS5rUMNGbRalO9X7yeA-1; Tue, 26 Oct 2021 12:12:20 -0400
X-MC-Unique: n0zpS5rUMNGbRalO9X7yeA-1
Received: by mail-ed1-f72.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so4273698edv.10
        for <kvm-ppc@vger.kernel.org>; Tue, 26 Oct 2021 09:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y/8qPSuga2nSdD4ObnPRjMzoPwBrPBTCysCx0s1aic4=;
        b=kPSUbqVHWmIkpnVFs3yW4OcXKJeGHH+vujW6ZQRSbq9JFh8jYiw0OBiEXDVG2lQlrt
         YQP2pqSeyfUmqFGXS8MwuVHOTX1FkAWw8Iw6ph89xi2IBC44CAXVYsY2rfJ6egLmDTRh
         QkpsSlJOW/vOI51rygDoUuoR1pJEG4YMwg/9USSwu919NLMazPQ2wwLojjWFpijVeg+A
         KBMA9qA62VcURJTpwVWd9zZXRtst8fFKnAnvdGvjprS+5EkuIrnSSctJAa/VaGDw6gct
         RcJJ8ce5jwBqkmNIi/YN0W+N5fXSWRJDGNBib1yI5fahrilxRzhHQvxqXpWmruL+7BY7
         Y2pw==
X-Gm-Message-State: AOAM531kmHGZhtYlehEt2quoHaWChUOWg+YXTRAboH6XBroMZskq783c
        eJCY2GzhrE9of3imHEaV5EwxHRTNuMeMTcjtew3MN+/0J1QujVxyklen193w/R++iAjSVYHUP7u
        u4BVPlQKIJzFFKbHsSg==
X-Received: by 2002:aa7:da84:: with SMTP id q4mr36991775eds.371.1635264738789;
        Tue, 26 Oct 2021 09:12:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwASeQAxYa4SVxx7fzZJcK2OTnFNOTNNHLf+PErJyPRemx/Rf7LwxYWqAfn33dB1Qf24eGGDw==
X-Received: by 2002:aa7:da84:: with SMTP id q4mr36991714eds.371.1635264738510;
        Tue, 26 Oct 2021 09:12:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n1sm4753815edf.45.2021.10.26.09.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 09:12:17 -0700 (PDT)
Message-ID: <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
Date:   Tue, 26 Oct 2021 18:12:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out
 arch callback hook
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
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
 <20211009021236.4122790-11-seanjc@google.com>
 <9236e715-c471-e1c8-6117-6f37b908a6bd@redhat.com>
 <875ytjbxpq.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <875ytjbxpq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 26/10/21 17:41, Marc Zyngier wrote:
>> This needs a word on why kvm_psci_vcpu_suspend does not need the
>> hooks.  Or it needs to be changed to also use kvm_vcpu_wfi in the PSCI
>> code, I don't know.
>>
>> Marc, can you review and/or advise?
> I was looking at that over the weekend, and that's a pre-existing
> bug. I would have addressed it independently, but it looks like you
> already have queued the patch.

I have "queued" it, but that's just my queue - it's not on kernel.org 
and it's not going to be in 5.16, at least not in the first batch.

There's plenty of time for me to rebase on top of a fix, if you want to 
send the fix through your kvm-arm pull request.  Just Cc me so that I 
understand what's going on.

Thanks,

Paolo

