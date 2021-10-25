Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB80439867
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Oct 2021 16:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhJYOYi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Oct 2021 10:24:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233490AbhJYOYg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Oct 2021 10:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635171734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HpaqUtGVB++dG0RuCTiBEYznGy9v/KDIt/5yYlz7/xg=;
        b=AWDyRtmXaPlPbYzj8fAN5bBexxIM6tuTRoW6wwZGk+WGblmxKtG5MyTVuWylZenb9CA0CL
        i3pU9wOQo2Tirj2iPAchWCF5sByL4bwwPAHxREgMydhUAgJL4u0zMm8U0923aU6Y6Dtp1H
        x+tl8/aF8EeAZhDeHJmG5ZMxHB0IO/c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-rZCdmOGoPx6ZuE7g6whOvg-1; Mon, 25 Oct 2021 10:22:13 -0400
X-MC-Unique: rZCdmOGoPx6ZuE7g6whOvg-1
Received: by mail-wr1-f70.google.com with SMTP id p1-20020adfa201000000b001669acb9bcdso3268327wra.13
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Oct 2021 07:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HpaqUtGVB++dG0RuCTiBEYznGy9v/KDIt/5yYlz7/xg=;
        b=42CL6csulktzXCzL6RxQLLKdeAtwBqrpczFpGGcPbKLv7U1UK/GEGY0ekj2UQ3qhPb
         c7NOxsKh8U5/4qTLx7PKhcVs88lyqFwnwlHvXn3/Tw4+gZ7uCBypL0PvK+DLbh652dWO
         YbHKAV1jvWKWY4HNhj4UOl7I8slhEV2Fluc8PmUupX0QA85qL8PzX1VTvxGlSQKeJR2R
         e5sZhaBEWa8EPKJ3B/igAWxrKg3EoOPGU8hdIPzEKcQVg6djinOQQMP9a69ceQWACb76
         bwl5FtnXF4toFfebhTjbgSb+auVaCfp0lhugVp5K3ZIlI+Ny+0jox/j2A75vFpFMZZCJ
         C2tQ==
X-Gm-Message-State: AOAM531uIm3kbmJnGGEYFPj+57bxmj0S/KNRlTH4q2+3CSFmXWgJ8ms0
        iOPLi5ZfGBSHP61WMbrrKc44L46AABNyEe74KS6w1k9Hya2ZT+yDHjg7/sSC/9fuqdOKCqcmJ7Q
        gHxnzHMcs7JErP+hdAQ==
X-Received: by 2002:adf:ef8f:: with SMTP id d15mr23887302wro.72.1635171731940;
        Mon, 25 Oct 2021 07:22:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzadqpNa9sRFm6T5pRsCXL5a0VdPZvR+Z2HC9JjGJpxIRL6ejj2cNhckiUN6d6SszWigGu00w==
X-Received: by 2002:adf:ef8f:: with SMTP id d15mr23887262wro.72.1635171731758;
        Mon, 25 Oct 2021 07:22:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v6sm2568505wrx.17.2021.10.25.07.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:22:10 -0700 (PDT)
Message-ID: <acea3c6d-49f4-ab5e-d9fe-6c6a8a665a46@redhat.com>
Date:   Mon, 25 Oct 2021 16:22:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running
 on vCPU load (with APICv)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
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
 <20211009021236.4122790-38-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-38-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/10/21 04:12, Sean Christopherson wrote:
> +	/* TODO: Document why the unblocking path checks for updates. */

Is that a riddle or what? :)

Paolo

> +	if (kvm_vcpu_is_blocking(vcpu) &&
> +	    kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
> +		kvm_vcpu_update_apicv(vcpu);
> +
> +		if (!kvm_vcpu_apicv_active(vcpu))
> +			return;
> +	}
> +

