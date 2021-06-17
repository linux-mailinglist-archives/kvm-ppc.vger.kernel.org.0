Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8DF3AB2CA
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Jun 2021 13:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFQLlb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Jun 2021 07:41:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229584AbhFQLlb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Jun 2021 07:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623929963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VmCLvCRTlrH58yubKa8HF1xENLoVvDewdsvG/LgtDCE=;
        b=LGhuhkP2RrAiDbAsWPwhdMg4/wzOODlHbn33LiWZYk0+eKPNfG2d3S1CSFnGN18EtB3lC5
        T3q5jtFTotADN+32jPdwBYOi8wjWOnOztJsOlyLAeKh9w8wFCmgHiDEBgH/V29oI/dHspo
        9hu4mLVP00qgAnOayMyP9xrhz90MHwU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-DjM1U9QHNUKQZaXrv7IdKA-1; Thu, 17 Jun 2021 07:39:21 -0400
X-MC-Unique: DjM1U9QHNUKQZaXrv7IdKA-1
Received: by mail-lf1-f69.google.com with SMTP id m12-20020a19520c0000b029030e4d9a1472so1922781lfb.2
        for <kvm-ppc@vger.kernel.org>; Thu, 17 Jun 2021 04:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VmCLvCRTlrH58yubKa8HF1xENLoVvDewdsvG/LgtDCE=;
        b=RVjhNRFQpb5zPZ5pA7wdF+963qerJxVG7CLs3//T3qLgYMQedgevuBZypY+7KsMZFX
         BpAMFBpekwGUxJrD0CNmPDKzk3TSuot5QXXLrYhl02A0r3d5obkPz1yHwVLvsPQRv0Xk
         qrji9jmwqzTnAGvugI25SQsU/Mt0u4IDGUdcT/zFmDzl7d2PvOTN8bbzbzpx8Vi2wwA3
         vzemMQckAOdv0TeWjVzKi+4+To1iSvcL/Asl1L0xrbaPQDApvOYMZqC+mJAsiMMJP61X
         XljNkizu1W7AjGXKBvkr0Zrcq6LfPRJlWZ9GMB+ozx9GGsWfIshDEGoIEKNUcgnXOisP
         TQIg==
X-Gm-Message-State: AOAM533EOevYA2nf0/tB1/yDR+y3Ey17/oR1UY+H/E6KtEOESXYTwS7P
        SF3kDW0o9yPnhTpJsnH65JDrv81pGAJAtrSFRWlYr+ZPuxFJLFvrmV1Gzr/Km7HbVDLP61WZjb6
        bEfLD9WJjKigc2kR3QQ==
X-Received: by 2002:a17:906:b317:: with SMTP id n23mr4753230ejz.324.1623929020526;
        Thu, 17 Jun 2021 04:23:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhbQ8ssqFmZsWb8sMpnt1Xu4dlg8VyEm5RPjNu6NQPEN0NLgvmdDkk7J48/7gKKGpvO8cI2w==
X-Received: by 2002:a17:906:b317:: with SMTP id n23mr4753201ejz.324.1623929020383;
        Thu, 17 Jun 2021 04:23:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id by23sm3167995ejc.85.2021.06.17.04.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 04:23:39 -0700 (PDT)
Subject: Re: [PATCH v10 2/5] KVM: stats: Add fd-based API to read binary stats
 data
To:     Greg KH <greg@kroah.com>, Jing Zhang <jingzhangos@google.com>
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
 <YMrzzYEkDQNCpnP7@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d8ca6601-e3b7-e6b1-5992-12ae106de951@redhat.com>
Date:   Thu, 17 Jun 2021 13:23:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMrzzYEkDQNCpnP7@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17/06/21 09:03, Greg KH wrote:
>> 3. Fd-based solution provides the possibility that a telemetry can
>>     read KVM stats in a less privileged situation.
> "possiblity"?  Does this work or not?  Have you tested it?
> 

I think this is essentially s/that/for/.  But more precisely:

3. Compared for example to a ioctl, a separate file descriptor makes it 
possible for an external program to read statistics, while maintaining 
privilege separation between VMM and telemetry code.

>>
>> +	snprintf(&kvm_vm_stats_header.id[0], sizeof(kvm_vm_stats_header.id),
>> +			"kvm-%d", task_pid_nr(current));
> 
> Why do you write to this static variable for EVERY read?  Shouldn't you
> just do it once at open?  How can it change?
> 
> Wait, it's a single shared variable, what happens when multiple tasks
> open this thing and read from it?  You race between writing to this
> variable here and then:
> 
>> +	return kvm_stats_read(&kvm_vm_stats_header, &kvm_vm_stats_desc[0],
>> +		&kvm->stat, sizeof(kvm->stat), user_buffer, size, offset);
> 
> Accessing it here.
> 
> So how is this really working?

It's not - Jing, kvm_vm_stats_header is small enough that you can store 
a copy in struct kvm.

Paolo

