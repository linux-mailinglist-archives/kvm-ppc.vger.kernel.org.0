Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D41D3AB2E8
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Jun 2021 13:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFQLsV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Jun 2021 07:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231593AbhFQLsV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Jun 2021 07:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623930373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ujv31ni+pedAzRqkqN94IhUeHH6igQoDkhQGmN9rbYg=;
        b=M6L1mTafPswJKarRnC+9Rg9l27Jrnsm2dzFzftOWOU3J6x3FYItDzIioiE1I95G+3C9zZ5
        QgGhMN/D5n7yalKArgMLAYiO3P2lac2c9pHsKyRJ9QV4Gu1fhEtLMibrOY4GjKDdKL8JeV
        GuJyY2yx5BcwDSFHUYo6BGu/vLEkr6M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-4wmkQZ6nN-GLIBQD95eyLQ-1; Thu, 17 Jun 2021 07:46:11 -0400
X-MC-Unique: 4wmkQZ6nN-GLIBQD95eyLQ-1
Received: by mail-ed1-f71.google.com with SMTP id h23-20020aa7c5d70000b029038fed7b27d5so1312946eds.21
        for <kvm-ppc@vger.kernel.org>; Thu, 17 Jun 2021 04:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ujv31ni+pedAzRqkqN94IhUeHH6igQoDkhQGmN9rbYg=;
        b=KVLJnWFm4DUBz8Fr60qM+SSoq8mAXS+5aRCEKF3dIkrO/yn0rPMevEUtXLc07ENZM9
         ix1LAne3Lc1rjRTtcprVnOlo7Vqn5R7J8mA+v6Zlzq2fcvhaqSLS5pzHYRauA+1iAAT7
         0hYZGFE629+KNoAAZb6wrF7Bosw7Qu96wKyENUR462YaOMPApD86JUD+H6OQMwNFCE0M
         0MdxxxsOQrNpsPtYeLPBJ0Jir3dDRlVfJZCAXWFdtm31DLMrULlvsXbFupdBCU4O3rHU
         P/UUBWmoYg8s+RaOsPVqK7o3TG50G5ZnIYr1ReFeZ5M5xIP6gQUCme4R8/0wKq7BAMt0
         M7XQ==
X-Gm-Message-State: AOAM533alXvplLgYIwFIbf318WzWVyMN0L6FP6IioEhdf/i6w4VFSjt8
        yoHVeHEAsXbEzBWrpkzaTaNQM7PY6B8NCAT8q2m55qmxNmdjqBLShbEEsZBg/CMI6NuTn71Y6S9
        jmsFctmkYzBF+eHRbug==
X-Received: by 2002:aa7:cf0d:: with SMTP id a13mr5826458edy.384.1623930370626;
        Thu, 17 Jun 2021 04:46:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGp0u6bbKTpBWAweRlzIakuy+NTS2L7DG9uaEaAYNed1OyNxc+QE79jbRlb3hr0uHlxKTUpw==
X-Received: by 2002:aa7:cf0d:: with SMTP id a13mr5826434edy.384.1623930370434;
        Thu, 17 Jun 2021 04:46:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t14sm1472804edr.36.2021.06.17.04.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 04:46:09 -0700 (PDT)
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
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
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com>
 <YMrkGZzPrt0jA1iP@kroah.com>
 <0d959828-da89-bceb-f7cc-35622a60c431@redhat.com>
 <YMs1Pwf+nSQsfVUW@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <348aa108-076b-04dd-9fd2-e840a7a85f5d@redhat.com>
Date:   Thu, 17 Jun 2021 13:46:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMs1Pwf+nSQsfVUW@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17/06/21 13:42, Greg KH wrote:
> On Thu, Jun 17, 2021 at 01:29:22PM +0200, Paolo Bonzini wrote:
>> On 17/06/21 07:56, Greg KH wrote:
>>> On Thu, Jun 17, 2021 at 04:41:44AM +0000, Jing Zhang wrote:
>>>> +string starts at the end of ``struct kvm_stats_desc``.
>>>> +The maximum length (including trailing '\0') is indicated by ``name_size``
>>>> +in ``struct kvm_stats_header``.
>>>
>>> I thought we were replacing [0] arrays with [], are you sure you should
>>> be declaring this as [0]?  Same for all structures in this document (and
>>> code).
>>
>> In C code [0] is a bit more flexible than [].  I think in this particular
>> case [] won't work due to how the structures are declared. In the
>> documentation [] is certainly clearer.
> 
> Look at all of the patches that Gustavo has been doing all over the tree
> for this work, you do not want to make him do this again here.
> 
> Gustavo, is [0] ok for fields like these?

I should be able to get back to KVM stuff later today, I'll check myself 
if [] can be applied and reply.  I had queued an early version of these 
for my local build to play with them but I haven't been able to do a 
complete review.

Paolo

