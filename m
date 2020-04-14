Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D531A83E2
	for <lists+kvm-ppc@lfdr.de>; Tue, 14 Apr 2020 17:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbgDNP5L (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 14 Apr 2020 11:57:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21222 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732395AbgDNP5J (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 14 Apr 2020 11:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586879828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+YYLNoHPS0R9msE++qaePEk7EKWnckmMQYzoCYqpJRk=;
        b=L5VaZIUX94Up2eOkbcGXD9ia6HQsLwWIG5x2EBP15ZVOAg0FYzA7/4JiAQ/Fn0e9zucPzj
        cijSY8Y2Y28v1AhrGRN49yO+erNIXQ/Z7xWUPdqMb98nGB9Iy07jDACxr9zzYzhaFqH2qr
        tzp5EynSZH27B3q5RamSSbSuYG38mL8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-mCpC-lmwPS-KnQbWRaLWMA-1; Tue, 14 Apr 2020 11:57:06 -0400
X-MC-Unique: mCpC-lmwPS-KnQbWRaLWMA-1
Received: by mail-wr1-f71.google.com with SMTP id h95so8899109wrh.11
        for <kvm-ppc@vger.kernel.org>; Tue, 14 Apr 2020 08:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+YYLNoHPS0R9msE++qaePEk7EKWnckmMQYzoCYqpJRk=;
        b=b8sWLfCTwT6PPwcICP7kMGtXkfJW98oV8bd1ZSHwaEbPIufKfYmoRJNZ0U6bEOY+mv
         jqEOzVcDW/0L0ZqwK+/wXWltORKUhkZNgh8ltmrWPryIatlb1d6SPJRA3RuPnIyyJBoz
         bfQCQN030qKesO4xppS6Y4bfV1TAYoUAJh+PltrGwnouBrer7hAP8yBBrEuQSvonArRV
         I4rsdA2AomurW/W/ixiFHXJnCh1njp3iQL9sjLcNFacYk68x7gbjAl9YKl3RlCKECmvS
         yiqmNKAiouKHdGV5h7QZ5CgK1E7NF+ooKinfl4sI9zTBagL6eu5Fxt3EzohVdnAQdvR3
         O7Ig==
X-Gm-Message-State: AGi0PuYHo+86AYgemBEtHrtTC5Hd2NDEjtEv4P5DaPfDWa9/sxtXkbfL
        nVXXAh+SJjY3uy+J0X8aABfMo/Lm2u/v0j0VxQVxCp3fLt8nHCEtGxAHaY+WLNUmPpYnkedVGcs
        2savJ9Zw63ieITYuPoA==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr502958wmb.93.1586879825160;
        Tue, 14 Apr 2020 08:57:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypK43hPUptF5L9yvQziVzJGJV/VyMhS23tlGH7dzBh06iijjr98+S1d6K1K1pTXXFtXi18cgZQ==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr502914wmb.93.1586879824909;
        Tue, 14 Apr 2020 08:57:04 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.210])
        by smtp.gmail.com with ESMTPSA id j10sm16390309wmi.18.2020.04.14.08.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 08:57:04 -0700 (PDT)
Subject: Re: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org
References: <20200413140332.22896-1-eesposit@redhat.com>
 <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
 <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <a5e9246e-2bf3-204e-b79b-0ed4c40fcc5d@redhat.com>
Date:   Tue, 14 Apr 2020 17:57:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 4/14/20 10:18 AM, Paolo Bonzini wrote:
> On 13/04/20 23:34, Philippe Mathieu-Daudé wrote:
>>> +#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
>>> +#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
>> I find this macro expanding into multiple fields odd... Maybe a matter
>> of taste. Sugggestion, have the macro define the full structure, as in
>> the arm64 arch:
>>
>> #define VM_STAT(n, x, ...) { n, offsetof(struct kvm, stat.x),
>> KVM_STAT_VM, ## __VA_ARGS__ }
>>
>> Ditto for VCPU_STAT().
>>
Hi Philippe and Paolo,
> 
> Yes, that's a good idea.  Emanuele, can you switch it to this format?

Sure, I just submitted the v2 version.

Thanks,

Emanuele

