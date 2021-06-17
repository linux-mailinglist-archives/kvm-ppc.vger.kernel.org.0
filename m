Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819DE3AB785
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Jun 2021 17:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhFQPb3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Jun 2021 11:31:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231661AbhFQPb2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Jun 2021 11:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623943760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pJAYrboxNY4R4lDYsyxGAHwG1E3b8kp8BFkfADBjg3E=;
        b=D64Fv/b+luWfIGTjMAtzpsXERz8LnKDbLDnnyiWBAjL6sQc5VFtDkSqlZ4/XYxQ6PEb4LH
        6WC0IDs/bxK0FDY2X6L+y0ixEX3QAxMjlPM9HFOKI2rNF3VPSZPpYCPP0R+tsG0xXyoEQ3
        CtFRYfuZ1YO/E4rNewQYAWdaF11zj2I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-nB4VqizRORO9vLLlj1SWcw-1; Thu, 17 Jun 2021 11:29:16 -0400
X-MC-Unique: nB4VqizRORO9vLLlj1SWcw-1
Received: by mail-ej1-f71.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso2395996ejn.10
        for <kvm-ppc@vger.kernel.org>; Thu, 17 Jun 2021 08:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pJAYrboxNY4R4lDYsyxGAHwG1E3b8kp8BFkfADBjg3E=;
        b=AWdVol5CQLT0UlEfWZ6z8uhq/HMNZcyVUp2ZbJWDBLAfxnM8DI4dMxwmVEIwC870EH
         NvqMZd53W9P714a4cJEdHpE6Gc83GwWE2QS3+p1ns41c7E+PfPm6WPHgclxWTPhA8KhA
         LpIoN4NFvqvaPueAOD08V/jpf3/IDhWeiAIJN0dsvUR7593giTlzkhZpqj5o07XnvfAV
         PNndHMm4mMvhY3XZ+7JJqv4lCvL4f77xKchgvoI5uoY2VJLB5c9iKg0zJCCgDcU0/+km
         mdAV8dLp0WFpNbsKxlbpdnGtQvCe9WGcQr1w2k/lNH8Xo2SWCwEFYoi4H7BUWZI/x3LP
         VPZg==
X-Gm-Message-State: AOAM53069P4iH14eH5nHPasiyQz+WBxqeVpyNvPk1/HqQSY03042DHji
        kHZtOySWHsYTpOO7FS3PPxAB+OklQATYRWw7q6J/kTjlC5OC9PF4BUMqDMfJcrEwvilqwxJ2NE9
        c9mY1wwhjj9qKrsmkRg==
X-Received: by 2002:a17:906:3c44:: with SMTP id i4mr5844970ejg.135.1623943755564;
        Thu, 17 Jun 2021 08:29:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwguprspLdKxfz1gQFsWZ9pANB4xL5Og2GYXcQQiXXJdl05NURoTWq9llwpGLS30bGiJxoGJQ==
X-Received: by 2002:a17:906:3c44:: with SMTP id i4mr5844929ejg.135.1623943755347;
        Thu, 17 Jun 2021 08:29:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z19sm4485528edc.90.2021.06.17.08.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 08:29:14 -0700 (PDT)
Subject: Re: [PATCH v10 2/5] KVM: stats: Add fd-based API to read binary stats
 data
To:     Jing Zhang <jingzhangos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-3-jingzhangos@google.com>
 <YMr4rArKvj3obDEM@kroah.com>
 <CAAdAUtiiQ0304vWR3Zm2XUKz374W4LY3=qdrFZCsQ27VkqMn9A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5ae75b1b-4cba-d06f-625b-35b42f11ac03@redhat.com>
Date:   Thu, 17 Jun 2021 17:29:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAdAUtiiQ0304vWR3Zm2XUKz374W4LY3=qdrFZCsQ27VkqMn9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17/06/21 16:56, Jing Zhang wrote:
> Actually, it is really not easy to separate this change into two patches even by
> following Paolo's suggestion. And it would be a surprise to userspace to see
> only VM stats, no VCPU stats.

That does not matter.  Having two or three patches is useful because it 
makes review easier; they will never appear separately in a release.

Paolo

