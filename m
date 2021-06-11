Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449F43A4033
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Jun 2021 12:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhFKKfA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Jun 2021 06:35:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231217AbhFKKfA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 11 Jun 2021 06:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623407581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WBC8jsi6sMgVpUZekFliEqdwU62og4a57VgKDjRa+Sc=;
        b=Kbo1bduKxHcMlJtsP8EmYeW4thj78zCb6mYjJxCjcEHDDQziKzra0btuJSBLBtM2NrIcSP
        ws783wS9ByuG9PXIDZD2c91dI3z36f/Rlilt8KSwSW9Nw9/gSyykyX/e7PeD9Mth32Nfwe
        eOpmaZ3rU9PvTZ2Ex07vi7cQFAQhKJI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-eYjdivVoONmxvB-DgAs6dg-1; Fri, 11 Jun 2021 06:33:00 -0400
X-MC-Unique: eYjdivVoONmxvB-DgAs6dg-1
Received: by mail-wr1-f69.google.com with SMTP id l13-20020adfe9cd0000b0290119a0645c8fso2428193wrn.8
        for <kvm-ppc@vger.kernel.org>; Fri, 11 Jun 2021 03:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WBC8jsi6sMgVpUZekFliEqdwU62og4a57VgKDjRa+Sc=;
        b=g2WrGmi5hClhTdp8lGMyDi24dICxme6V6Ys00z/MtGyJL2urQKGyP/zwJ30w99GQNo
         1GNc+qqIeumDKZJMcuJBh2EnJyjC7DXqBnI6KH7T37MYqeq62oCtp8M+yseI4TLQOY/2
         sz3NpaSebmAAW+R6Gi5gsxkCp1wXEFl7PveWOE1MUL4EAf0YUnwNU2mDFeP1WoEjUjTm
         XGJsIPRrbp/NB0OCyc4K15j56jICnrT8REb5BUIB476m4kdsCCnF+lPQE05Dff3webn9
         LzIGsnUH+0njHa9nhdSQpZryji4yOzI1FTl/yo1RDE/XJjl/JCcXCumHjF4fHtpS2kH9
         hCJQ==
X-Gm-Message-State: AOAM532wIYl2G5h47OU4K5I85UJzWJ2ZLBJsTN3+EPba0Czr7BmCAzDg
        1EnGIfc6dTXqTSv8HgIyOwd3aXuc8ORVYsxUww+vHfeYRIjrKN+dhcRjPPNckZ8shJrkOVIZCZT
        pWtmmD55DtBS/7EBt8Q==
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr2224949wrb.255.1623407579425;
        Fri, 11 Jun 2021 03:32:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf8tRH1WD2BkDk0nh3u9+JxAlR1FoBopNGcMDh/7aHVklUCngEpCzpbjrac9bNu9rkTLOqQw==
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr2224904wrb.255.1623407579190;
        Fri, 11 Jun 2021 03:32:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s62sm12741514wms.13.2021.06.11.03.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 03:32:58 -0700 (PDT)
Subject: Re: [PATCH v7 2/4] KVM: stats: Add fd-based API to read binary stats
 data
To:     Jing Zhang <jingzhangos@google.com>
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
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com>
 <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
 <CAAdAUtjAuDdyBz7qd7UE0WuY77US-bhY1-jA9E11ddhZ0=gw6g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2ed4afbf-c5b8-82a5-5fc6-04f00f933761@redhat.com>
Date:   Fri, 11 Jun 2021 12:32:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAdAUtjAuDdyBz7qd7UE0WuY77US-bhY1-jA9E11ddhZ0=gw6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 11/06/21 00:47, Jing Zhang wrote:
> Hi Paolo,
> 
> On Thu, Jun 10, 2021 at 11:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 03/06/21 23:14, Jing Zhang wrote:
>>> +#define DEFINE_VM_STATS_DESC(...) {                                         \
>>> +     STATS_DESC_COUNTER("remote_tlb_flush"),                                \
>>> +     ## __VA_ARGS__                                                         \
>>> +}
>>> +
>>> +#define DEFINE_VCPU_STATS_DESC(...) {                                               \
>>> +     STATS_DESC_COUNTER("halt_successful_poll"),                            \
>>> +     STATS_DESC_COUNTER("halt_attempted_poll"),                             \
>>> +     STATS_DESC_COUNTER("halt_poll_invalid"),                               \
>>> +     STATS_DESC_COUNTER("halt_wakeup"),                                     \
>>> +     STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                          \
>>> +     STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),                             \
>>> +     ## __VA_ARGS__                                                         \
>>
>> Let's instead put this (note it's without braces) in macros like these
>>
>> #define KVM_GENERIC_VM_STATS()                                                  \
>>          STATS_DESC_COUNTER("remote_tlb_flush"),
>>
>> #define KVM_GENERIC_VCPU_STATS(...)                                             \
>>          STATS_DESC_COUNTER("halt_successful_poll"),                             \
>>          STATS_DESC_COUNTER("halt_attempted_poll"),                              \
>>          STATS_DESC_COUNTER("halt_poll_invalid"),                                \
>>          STATS_DESC_COUNTER("halt_wakeup"),                                      \
>>          STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                           \
>>          STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),
>>
>> and it can be used in the arch files.  In fact it can even be added in patch 1 and
>> switched to STATS_DESC_* here.
>>
>> Paolo
>>
> I just remember that the reason I used braces is due to following
> error from checkpatch.pl:
> ERROR: Macros with complex values should be enclosed in parentheses

No, just ignore the bogus error from checkpatch.pl.  But, thanks for 
checking!

Paolo

