Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD63A7C9E
	for <lists+kvm-ppc@lfdr.de>; Tue, 15 Jun 2021 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhFOLFq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 15 Jun 2021 07:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229918AbhFOLFp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 15 Jun 2021 07:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623755021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iEAQAQmkLLT7lE0HbV2Awm5nECfUPpZCvFSfqi2dN24=;
        b=dgU/gWK0iVVvZnA7dQMnHYQsjxQh186wjN2Y59+jDfpuXAi/C/jQh59iVs45YCtdWpeh2I
        WrIv/ZsxXitFxUTtDE/jZE4TT4Vk8D5ShGgDY8cmAfLeptx4Hgcc8dVnzpShkbedDH9GFW
        R2+QwFP8emCv4zImix8NIEAkmpUGA1g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-A3lv65UiMzOU84q2S88MfA-1; Tue, 15 Jun 2021 07:03:40 -0400
X-MC-Unique: A3lv65UiMzOU84q2S88MfA-1
Received: by mail-ed1-f70.google.com with SMTP id y16-20020a0564024410b0290394293f6816so4614283eda.20
        for <kvm-ppc@vger.kernel.org>; Tue, 15 Jun 2021 04:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iEAQAQmkLLT7lE0HbV2Awm5nECfUPpZCvFSfqi2dN24=;
        b=clzRto6e+FPV5i2ShQCy6ALZPOpsiNBHADbKlcMsQRh/QvV1XpHWK9UagYoF2rg1mY
         L7UUNMSdzDmfc3oxo0+ORNHa8xZMGH4bMKO5Yhsh1LCnPQrothyWIcSnaidbz5BXStZe
         55eGDSigzyA9JYUomVWvO8wAjFrUmvdLMz+FPbdIieDA9SeKQ+0vEXTeeQ4vL3A87grJ
         aWdtGrxWAq4+pBHXlgkx9YdD9tcmkTK9Zdkif/bi8IKR9f8iDsArbgIkzaQ0rX3Ys9W5
         4KwHdq3Cec9lH8kqNogpioIsVAcCpWJ+IAFZyCiu0HqQohTZo2tyDEYC51dz3zs2tqbr
         ju0Q==
X-Gm-Message-State: AOAM53295E7EqWSRtw7v7mXGZUKBtNAvoho+gzH8qDL2+61wo7DnMj06
        RFMJjjpmoqg9FhK5JggqxSwB2sOrTaosQUMR1evq0UzSkRD3LetOD4KVFLY4Heexc+W04VPFXc+
        KHec9I0Ee+cqxnQoW5w==
X-Received: by 2002:aa7:cb90:: with SMTP id r16mr22601060edt.121.1623755019217;
        Tue, 15 Jun 2021 04:03:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyVGoTcEFV+m9u1f3g2PKtrTco2TK6Sy4Mfoi+BgNSLuNotL7Uvem+oaDEtZ7dwo5Mk49IJg==
X-Received: by 2002:aa7:cb90:: with SMTP id r16mr22601014edt.121.1623755018970;
        Tue, 15 Jun 2021 04:03:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h8sm10123527ejj.22.2021.06.15.04.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 04:03:38 -0700 (PDT)
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
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
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <YMg5xPbmK3myjIX8@unreal> <15875c41-e1e7-3bf2-a85c-21384684d279@redhat.com>
 <YMhcek2cIu3Oz5Ek@unreal>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
Message-ID: <9df462c0-e0ea-8173-0705-369d6a81107c@redhat.com>
Date:   Tue, 15 Jun 2021 13:03:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMhcek2cIu3Oz5Ek@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 15/06/21 09:53, Leon Romanovsky wrote:
>> Sorry for my naive questions, but how does telemetry get statistics
>> for hypervisors? Why is KVM different from hypervisors or NIC's statistics
>> or any other high speed devices (RDMA) that generate tons of data?
>
> So the answer to the question "why KVM is different" is that it doesn't
> have any stable identification except file descriptor. While hypervisors
> have stable names, NICs and RDMA devices have interface indexes etc.
> Did I get it right?

Right.

> And this was second part of my question, the first part was my attempt to
> get on answer why current statistics like process info (/proc/xxx/*), NICs
> (netlink) and RDMA (sysfs) are not using binary format.

NICs are using binary format (partly in struct ethtool_stats, partly in 
an array of u64).  For KVM we decided to put the schema and the stats in 
the same file (though you can use pread to get only the stats) to have a 
single interface and avoid ioctls, unlike having both ETH_GSTRINGS and 
ETH_GSTATS.

I wouldn't say processes are using any specific format.  There's a mix 
of "one value per file" (e.g. cpuset), human-readable tabular format 
(e.g. limits, sched), human- and machine-readable tabular format (e.g. 
status), and files that are ASCII but not human-readable (e.g. stat).

Paolo

