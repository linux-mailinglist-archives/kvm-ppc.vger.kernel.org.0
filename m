Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2A016855F
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Feb 2020 18:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBURsD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 Feb 2020 12:48:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60375 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727137AbgBURsD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 Feb 2020 12:48:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582307282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RrMvZJoVJBWqnzqNr9KyLlzqZ46CEJlOdAIqg//g6XU=;
        b=dIe+RgCzUCc+j7/6priU5r1awTTJQpfHKW2bI2qO6EjtMl47Qz3hE64Uw/VgBVyGkzxC42
        2zU1dBq0ERQMUFnIFWtvhrgWHJRJfV3GxpUdsIJ1MhKCGjYxobTul+jQSvkfmgaPas+dOm
        /FAGwnA7Pd7J02ViLqFWSUZZGWvZkEY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-2BB5_7O4N7uJ5RW4OLZtDg-1; Fri, 21 Feb 2020 12:47:56 -0500
X-MC-Unique: 2BB5_7O4N7uJ5RW4OLZtDg-1
Received: by mail-wr1-f70.google.com with SMTP id j4so1334758wrs.13
        for <kvm-ppc@vger.kernel.org>; Fri, 21 Feb 2020 09:47:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrMvZJoVJBWqnzqNr9KyLlzqZ46CEJlOdAIqg//g6XU=;
        b=OUfU0rZRSu2d0Oi41oZILdtYAztNglz64EzCXllZB7ns70NTvaeNujboF32LMOeIVy
         HAcIjcX78Juoq9xbYgVPFrQyvrUrKKZVPesA9Jr6fBNR6L0NIeoV3iab7HEGUmAuh5F+
         hlwmH231T5ybBZsRv6Z/RbcE19saOwkBdQKU/WEu/2Kh22JMe3O/xNkrTAr1jDTwmXvt
         8U83qg5Erfhvq6aKoaqSBcAZXkUy+EdfTT4H2BjwR1vkYNJ9UenxlDaxV4y3A6wkJbyu
         UUft51SRPUF1TzUfJsLT3P9fY2mj2l0mtA+tNoqfOs2Q0Vw0iQfiFRm2nJ/OefLvIUbp
         NlUQ==
X-Gm-Message-State: APjAAAUKptzc2SKja0ajU0x6ZWHUVcpQOUoZEKlbDCCOrMRGVs9ahE1+
        40rxAffYOLoFDPOnPh8hv49NbqFfWIIEaAOaj82EOQUwp+kDxFzOUPwa6mvkzPOO2pvMRqk5ynH
        fB8e9rGUt2/Wn0dtyVg==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr49225891wrm.349.1582307275644;
        Fri, 21 Feb 2020 09:47:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqzI29TQnMTxhegOPTR5SZPy7HDTeZP8mdmwqeW3b3wvRv6t/VcN7GX1ZnOVCmuZ9M9Iv9A8Vg==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr49225876wrm.349.1582307275388;
        Fri, 21 Feb 2020 09:47:55 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id x6sm4531952wmi.44.2020.02.21.09.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:47:54 -0800 (PST)
Subject: Re: [PATCH v6 17/22] KVM: Terminate memslot walks via used_slots
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-18-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <216d647a-e598-d5d6-e20f-9c44c9ca157f@redhat.com>
Date:   Fri, 21 Feb 2020 18:47:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218210736.16432-18-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 18/02/20 22:07, Sean Christopherson wrote:
>  	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> -	old = *tmp;
> -	tmp = NULL;
> +	if (tmp) {
> +		old = *tmp;
> +		tmp = NULL;
> +	} else {
> +		memset(&old, 0, sizeof(old));
> +		old.id = id;
> +	}
>  

So much for my previous brilliant suggestion. :)

Paolo

