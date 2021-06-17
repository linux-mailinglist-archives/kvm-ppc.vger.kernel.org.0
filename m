Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D317B3AB26C
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Jun 2021 13:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhFQLZW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Jun 2021 07:25:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36441 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232478AbhFQLZW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Jun 2021 07:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623928994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeoOEjtdTbZHikE6qVHZkIHtsqJ8oL1MWdn59al3yJU=;
        b=KiOL1LFF+OgPuMHfkFB29XSzACHA+dYkMsh4QdObGEwoiC4M9Cfx+eOeqjszUd5dEgyNOb
        fPv/7ChKcrC6RcOYFSrd+Zw8I1AF5l/fsHPV8Au8xZn5ScOAr/yTefDhHvahW5X+WAX4wp
        mSHHZ+3mKmhpt8vpyrvzGhh/MARfuH0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-2x6qlpWyP3iTS5r2WD4NMA-1; Thu, 17 Jun 2021 07:23:13 -0400
X-MC-Unique: 2x6qlpWyP3iTS5r2WD4NMA-1
Received: by mail-ej1-f72.google.com with SMTP id mh17-20020a170906eb91b0290477da799023so1352983ejb.1
        for <kvm-ppc@vger.kernel.org>; Thu, 17 Jun 2021 04:23:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QeoOEjtdTbZHikE6qVHZkIHtsqJ8oL1MWdn59al3yJU=;
        b=Dhhgcdrm73nGl3AWBK9Du3jzPj5DAgiPt1OGFTJyDxHIiMw/+3mD88nskHqX2Q3qjv
         Iz/iLWR5G60n9ZMY8LpnuuvYDbo4NXDyEIhXqU23hi7IReWPAdEYMicMojx+wfV4xgRA
         bwe7lekL5LFlCEJnqiaQxSjw3g3IZFUz7jBgMiHvnRmWIvyJ6DbwXBfpJ1sZ7TABnbbi
         KVP2xsFJFSBSCkUGkBun60TGu/8sf5JBqfWKyAmCGc1bv24pfStlXKvRHB6e/SLF8tof
         11CWiuj6/5F/cerRxFD0IsjyrF5LAyjdibfJ1194aGQQ9M7ivmVmsCeuVbkLV7Wom9eR
         Ri/g==
X-Gm-Message-State: AOAM531mkDnY9dtRI2Vs8Qh2UTWfBm+gRO+F5gw4tKo+EwI1Om8nkfao
        dHssdOebK+AG8XdHGbnXFcOnjPYtFG6tG2vz1LE3ti6W9K33AKaq28+BT12rs77sjmWIm5Ol8aw
        dMAywuGWt/4/tpHYSlw==
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr5799047edd.228.1623928793192;
        Thu, 17 Jun 2021 04:19:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc8lc8kbfFsQbKsVnuEADgPqEmYVAvmC/1IvjtxjrXOO4gKYpFUgt0NPkDolV15GoZuo9rTg==
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr5799027edd.228.1623928793011;
        Thu, 17 Jun 2021 04:19:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e18sm3537900ejh.64.2021.06.17.04.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 04:19:52 -0700 (PDT)
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jing Zhang <jingzhangos@google.com>
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
 <20210617044146.2667540-4-jingzhangos@google.com>
 <YMrmqOxDWJ2/8sfD@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be506135-5bc3-31bd-1b20-063f01f41df1@redhat.com>
Date:   Thu, 17 Jun 2021 13:19:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMrmqOxDWJ2/8sfD@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17/06/21 08:07, Greg KH wrote:
>> The statistics data itself could be read out by userspace telemetry
>> periodically without any extra parsing or setup effort.
> Do you have a pointer to userspace code that can do such a thing that
> others can use?  We do not like adding apis to the kernel without at
> least seeing the user of those apis, especially for complex things like
> this.
> 
> Ideally you would include some library code in the kernel tree itself
> that everyone can use for this for their own programs.  You have
> provided a test which is great, but how do we know it works for "real"
> usages?

I am pretty sure that Google is using this internally, but we are also 
going to work on QEMU and Libvirt support for this.

As for the rest, thanks for the review---I'll let Jing act on it and 
only add my own remarks in a couple places.

Paolo

