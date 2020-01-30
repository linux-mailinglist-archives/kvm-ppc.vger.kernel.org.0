Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F2114D637
	for <lists+kvm-ppc@lfdr.de>; Thu, 30 Jan 2020 06:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgA3FoQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 30 Jan 2020 00:44:16 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54220 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbgA3FoP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 30 Jan 2020 00:44:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580363054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8PEF8AVAWODPDupJea+4sWEJHHfwQkjaA/7qcZmag4=;
        b=Y6R00qTGMkNZUDTi9Bjzix9BllX0aNbcel38FTI/KrI0Gy8ohOqOO1Bo+f8ANxQ1udmsI+
        9gc93iPBE/sR02iBoU12Jc/3Qc6eX62uUl1dMn9j+vUyG+JNRIzIuJRkCkDUz+nQ7AQlt3
        2i8of8hMPtwPYKMTBmpP5X7h+dsdlcs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-0bBigFh6MZ2tMCGu_XBPEw-1; Thu, 30 Jan 2020 00:44:12 -0500
X-MC-Unique: 0bBigFh6MZ2tMCGu_XBPEw-1
Received: by mail-wr1-f70.google.com with SMTP id t3so1198537wrm.23
        for <kvm-ppc@vger.kernel.org>; Wed, 29 Jan 2020 21:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b8PEF8AVAWODPDupJea+4sWEJHHfwQkjaA/7qcZmag4=;
        b=D6H28OY3ivP3W/YEWYpHDJkmoTmM2JdJn8W6jS2QgR9TjT6+C6qQCo1elzP907GZ/n
         P5XMhrRjuE8hrQkarcgjJeRcX2hl+Y2nZDorXLM5e/mA0LX39u++GLRhFJqsGXCN6az3
         Xy8PXesDiPoGrzJXD5F6YPLj3JNBguvV+rqFwH14G8SD9EQshgpz23FuftsXuD12dQIo
         NlRb2EmdW+2Q2EsK67geEeVNgF189Yjp14zlLbExPm2X2h80XgfT2k9PBxHg5TwmV4lr
         LMhFSOPOLu4UqZHIHkv2OeZ1RylGUhtu23TEtkMQh4DKjbOrnS4Wzd3tKItjn57szICH
         f1jw==
X-Gm-Message-State: APjAAAUy1ezt66+/xD1cHdNEsI6yAFBOy3uw/E9kYMhNtQVKR4IoLChG
        TIR23z84pbsCXCVNVSjSeKYqcZILQ44CutMq9RFHY+9rfPM0im671kYo4Ug8Y/MnU2xD9rrXMV4
        TKs+X4Vxbxjf6/5h30g==
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr3175375wmi.21.1580363051239;
        Wed, 29 Jan 2020 21:44:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvrtUyXEqgq8iYKVpAB/LAj4fC31bOc+VOTWRDvsFWxjJ6sWsl8qJGadVTcya+7iE6vbimVA==
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr3175335wmi.21.1580363050959;
        Wed, 29 Jan 2020 21:44:10 -0800 (PST)
Received: from [10.1.251.141] ([80.188.125.198])
        by smtp.gmail.com with ESMTPSA id 4sm4795049wmg.22.2020.01.29.21.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 21:44:10 -0800 (PST)
Subject: Re: [PATCH 5/5] KVM: x86: Set kvm_x86_ops only after
 ->hardware_setup() completes
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
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
 <20200130001023.24339-6-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <44e0c550-7dcc-bfed-07c4-907e61d476a1@redhat.com>
Date:   Thu, 30 Jan 2020 06:44:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200130001023.24339-6-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 30/01/20 01:10, Sean Christopherson wrote:
> Set kvm_x86_ops with the vendor's ops only after ->hardware_setup()
> completes to "prevent" using kvm_x86_ops before they are ready, i.e. to
> generate a null pointer fault instead of silently consuming unconfigured
> state.

What about even copying kvm_x86_ops by value, so that they can be
accessed with "kvm_x86_ops.callback()" and save one memory access?

Paolo

