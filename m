Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D343CDBB
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Oct 2021 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhJ0Pi7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Oct 2021 11:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238643AbhJ0Pi5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Oct 2021 11:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635348991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5uRyMZIN45jCj2VKDrWR2a9G78BQWuHGJKl7OtHJZ6k=;
        b=e2dR+en+X1RDREBLLt64xZsmtbn2gJbApYWO5LX8Vut55CfpXVAk81mSZdLNxqHu/Ho85b
        ubVa4Dq6esUrtQxHn2He/jDyHvGeNyRITA+GUK+2vIMqB8clziqaw2gtKhvjWKphvPlBXg
        387CZYQIr/IItEkZlX7eLGEgp9R0xts=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-bk2e5rNCNFufL3huiCqStA-1; Wed, 27 Oct 2021 11:36:30 -0400
X-MC-Unique: bk2e5rNCNFufL3huiCqStA-1
Received: by mail-ed1-f71.google.com with SMTP id t1-20020a056402524100b003dd9a419eb5so2713228edd.4
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 08:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5uRyMZIN45jCj2VKDrWR2a9G78BQWuHGJKl7OtHJZ6k=;
        b=p6I3Nw6UZ3kabiVMutms6C/txaOf068++/s738n2XhdgEza/7G/87Z46dA0d4sdJJC
         D4Q+kZjHHvVEqBaMe54AkKklspxSGi1l7+qVqU9qzOM8f2QZJ7dBZHxe3XDfFAisC4mF
         UJOUg72+GE6KPd1P9boQ6J5rSfQHibeBKxI0sBkKYyH9Z0+c6Lfd9fl0Ylwl5wfgk6tL
         PhZ5+/EvqdZhDTzjr5FIisMJTFvjNJlOCgJCZOmwF8dqsiQ9MjosbPhU2/QW8iQAoNBI
         yliOT+Vdiay+e0QXeLcqWJS4pzBh22E46q9llenPVlsdn1hJVW8o/GdZ5FX6TszAZfOD
         oijA==
X-Gm-Message-State: AOAM532AMNGSET6g25oHOsFlhSYMOsJyPKzsIkfAaojT8SjAhmBotFO/
        V6NzgFyNZnB7LtJGhY05LOdyL04zLZSGrYZWenEwbXe9uBPyvK43fD5ddAYIthFF+OUIqMxAVxN
        7GLG67j4RCJ4T9qFE4w==
X-Received: by 2002:a17:907:72d4:: with SMTP id du20mr27123513ejc.324.1635348988860;
        Wed, 27 Oct 2021 08:36:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlnTQW53CgmXIn8to0kDTGFp7NuPe5vIqIt10aS0tdUzKBzxmlSrEKcMCaMlb8sNDTKtez8Q==
X-Received: by 2002:a17:907:72d4:: with SMTP id du20mr27123484ejc.324.1635348988605;
        Wed, 27 Oct 2021 08:36:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dx2sm110885ejb.125.2021.10.27.08.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:36:26 -0700 (PDT)
Message-ID: <185502d7-861e-fa5c-b225-419710fe77ed@redhat.com>
Date:   Wed, 27 Oct 2021 17:36:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in
 guest mode
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
 <20211009021236.4122790-36-seanjc@google.com>
 <0333be2a-76d8-657a-6c82-3bb5c9ff2e3b@redhat.com>
 <YXlrEWmBohaDXmqL@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXlrEWmBohaDXmqL@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 27/10/21 17:06, Sean Christopherson wrote:
>> Does this still need to check the "running" flag?  That should be a strict
>> superset of vcpu->mode == IN_GUEST_MODE.
>
> No.  Signalling the doorbell when "running" is set but the vCPU is not in the
> guest is just an expensive nop.  So even if KVM were to rework its handling of
> "running" to set the flag immediately before VMRUN and clear it immediately after,
> keying off IN_GUEST_MODE and not "running" would not be wrong, just sub-optimal.
> 
> I doubt KVM will ever make the "running" flag super precise, because keeping the
> flag set when the vCPU is loaded avoids VM-Exits on other vCPUs due to undelivered
> IPIs.

Right, so should we drop the "if (running)" check in this patch, at the 
same time as it's adding the IN_GUEST_MODE check?

Paolo

