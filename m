Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BC343999A
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Oct 2021 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhJYPHu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Oct 2021 11:07:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233661AbhJYPHt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Oct 2021 11:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635174326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17YKkfI8G+c9Iih6iy4QvMoudnAtBOzRU5Sn0sW8tZE=;
        b=aUowJOSEezruPAV5aYjmQ+lYK4PnUPZm2rdY0GZqKxlRyLjdAP8jYom4/YgWe9sjL8zZ+v
        L3KR9DA0JY8x+SfbqhPtmpp/557AsSNAybKVKckopLoiKnXSjsfAyqGfRwkyfSg/iN8ynJ
        R8xOs0MQVRjRt5Mnl0wbHjoPgnBwGg8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-WHwdVsYJP6uDO3Ihrj9cHA-1; Mon, 25 Oct 2021 11:05:25 -0400
X-MC-Unique: WHwdVsYJP6uDO3Ihrj9cHA-1
Received: by mail-wr1-f72.google.com with SMTP id m5-20020a5d56c5000000b00168861c65f9so1732700wrw.0
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Oct 2021 08:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=17YKkfI8G+c9Iih6iy4QvMoudnAtBOzRU5Sn0sW8tZE=;
        b=2obRNX7iF6n+JfQPPi4Kr0i+IgblgC2ANlLvce2PwFnYCK5I0RHnt93D6LHz74FaXE
         /q9eW0rxLlwVsbOL1egOHUAGiFhnNDr8bbNVe9QfXVXrK6MLnPV+JxOdv1Kr/z3uHsvw
         RHjv667nqvOl/G+1jw6OJfflMrFXn9HhqntPPlahEfL2f9a/nZaBzsvFC7CWVFP3JKDL
         5lxQR/VHlcyBLeN+uHc0COaAR/H07qVA3nDl9O/bQKtCvq0bTF5qtVFTOEMgQ5e2XTdQ
         O7wiCTMzM03YIm98HYjEJ0AzYHw5LvgJHOdV+jNC9LporIjMvez3qdYbch1E6/tvxOBW
         Qi2w==
X-Gm-Message-State: AOAM531hHEIvADelsLA2UxDE2g2l2wJYT0hWkiC7aKa6Vz9ujHjVbv3v
        ZkXbLiIRFxi5cNKzmqk7IrmJWwCCt2407tyveZCE4MEVNjHAX6ktSMVQTeFSqN7QyDIi+W+oOhI
        dYzbADOzwXCVDPtN1lQ==
X-Received: by 2002:adf:b1d7:: with SMTP id r23mr24328028wra.145.1635174324218;
        Mon, 25 Oct 2021 08:05:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNexQuzHRq+jpnX8KTr0omvqAmOMBdWB1dnxyBAmmWnxN2QzlfyX1PUJV+JR7ASMMz0R8mMg==
X-Received: by 2002:adf:b1d7:: with SMTP id r23mr24327978wra.145.1635174323914;
        Mon, 25 Oct 2021 08:05:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w10sm9256784wrp.25.2021.10.25.08.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 08:05:23 -0700 (PDT)
Message-ID: <a2a4e076-edb8-2cb5-5cb2-6825a1a4559a@redhat.com>
Date:   Mon, 25 Oct 2021 17:05:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 40/43] KVM: VMX: Wake vCPU when delivering posted IRQ
 even if vCPU == this vCPU
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
 <20211009021236.4122790-41-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-41-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/10/21 04:12, Sean Christopherson wrote:
> 
> Lastly, this aligns the non-nested and nested usage of triggering posted
> interrupts, and will allow for additional cleanups.

It also aligns with SVM a little bit more (especially given patch 35), 
doesn't it?

Paolo

