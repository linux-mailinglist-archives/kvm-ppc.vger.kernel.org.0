Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E220443D64E
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Oct 2021 00:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhJ0WMR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Oct 2021 18:12:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229885AbhJ0WMN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Oct 2021 18:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635372587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPTDsq9RY16fTCCoMhEcqKhkYxR/hT5AGgzHMhJ6ojY=;
        b=GW84Vw7pza+og6AlQkSStDCr+1P5nspQ7TtvSEueKXYKAkG62c75otaTSgTDcHmZeCWVfT
        uwTNQTOGQCU7TvhtCZdIIeGUW18IXf5YInxnS1/X/q/y1v6tUSxRouck3/RjgSajycTUij
        gK+XzfOD7Ppyo2nzL6zjKY+Izr8o0ZI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-1M5eDWr-OWytkafSZPmYUw-1; Wed, 27 Oct 2021 18:09:45 -0400
X-MC-Unique: 1M5eDWr-OWytkafSZPmYUw-1
Received: by mail-ed1-f71.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so3645137edi.12
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 15:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vPTDsq9RY16fTCCoMhEcqKhkYxR/hT5AGgzHMhJ6ojY=;
        b=hp7tE7bH7vwazPk2yw7wACct9ss/aORUQjbHReDhpL43sC1ehYe/COtdgzwTAGPwlS
         1V7gJnmb14eaaZ2MmQrjvgJwLW5abATdyLPkNJP+lmq7GI6ETeYrsLNDJgXK0fPRl72r
         7weychC5yETc7cn7APCwn7iEbRujSMdA0mBVjklOc6TRCPh/1aSijLvJuCs27mbmMHX5
         qHUMKeectakdcTl2thd7lIzIJeldoWuEHDOGHmzJ+9n9YeLudacnMeNXdwPLqrUwcGbk
         eKnim4xTLjgWtSjdKdp1Ix0+09CdrA386D6UO5dl05sM643oxOLRs1aHJffpw0giruqW
         yJkA==
X-Gm-Message-State: AOAM532+d0qJbZJCqnVFAS6LwSFUaOnTkxl8sSoF9lrme3eu5S0DNZ7G
        atsN6IuMmN31dL3ZAqITVlQg69DT7GlonMjSx5sMr5vMxs3BNlIG41T2VXGJnQ+l+AU1Xtt9PEA
        CwQsxqNj6SY97AO5W6w==
X-Received: by 2002:a17:906:3f95:: with SMTP id b21mr341851ejj.368.1635372584297;
        Wed, 27 Oct 2021 15:09:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoBx4vKjR30o+Kgjfdb4KsDUE6yjTUINxxdU8F5+6sRGk01DyvRy4bEl13EnJPgWSCV29mNQ==
X-Received: by 2002:a17:906:3f95:: with SMTP id b21mr341810ejj.368.1635372584078;
        Wed, 27 Oct 2021 15:09:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a9sm675279edm.31.2021.10.27.15.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 15:09:43 -0700 (PDT)
Message-ID: <fdf90c2f-81c8-513b-2e06-a90959f4cd89@redhat.com>
Date:   Thu, 28 Oct 2021 00:09:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 39/43] KVM: VMX: Don't do full kick when triggering
 posted interrupt "fails"
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
 <20211009021236.4122790-40-seanjc@google.com>
 <335822ac-b98b-1eec-4911-34e4d0e99907@redhat.com>
 <YXl4mK7CyUBnPaQV@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXl4mK7CyUBnPaQV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 27/10/21 18:04, Sean Christopherson wrote:
>>> +		/*
>>> +		 * The smp_wmb() in kvm_make_request() pairs with the smp_mb_*()
>>> +		 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU
>>> +		 * is guaranteed to see the event request if triggering a posted
>>> +		 * interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
>>
>> What this smp_wmb() pair with, is the smp_mb__after_atomic in
>> kvm_check_request(KVM_REQ_EVENT, vcpu).
>
> I don't think that's correct.  There is no kvm_check_request() in the relevant path.
> kvm_vcpu_exit_request() uses kvm_request_pending(), which is just a READ_ONCE()
> without a barrier.

Ok, we are talking about two different set of barriers.  This is mine:

- smp_wmb() in kvm_make_request() pairs with the smp_mb__after_atomic() in
kvm_check_request(); it ensures that everything before the request
(in this case, pi_pending = true) is seen by inject_pending_event.

- pi_test_and_set_on() orders the write to ON after the write to PIR,
pairing with vmx_sync_pir_to_irr and ensuring that the bit in the PIR is
seen.

And this is yours:

- pi_test_and_set_on() _also_ orders the write to ON before the read of
vcpu->mode, pairing with vcpu_enter_guest()

- kvm_make_request() however does _not_ order the write to
vcpu->requests before the read of vcpu->mode, even though it's needed.
Usually that's handled by kvm_vcpu_exiting_guest_mode(), but in this case
vcpu->mode is read in kvm_vcpu_trigger_posted_interrupt.

So vmx_deliver_nested_posted_interrupt() is missing a smp_mb__after_atomic().
It's documentation only for x86, but still easily done in v3.

Paolo

