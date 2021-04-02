Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2C13528E6
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhDBJfn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Apr 2021 05:35:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234856AbhDBJfn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 2 Apr 2021 05:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617356141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pp7i/Rq4quxGmDckgflEr0uWdxRmtTCzqRhgMxNYmVI=;
        b=HVPYN/Au8+htd9ozI7CJcI37JaDjISuq37mWdtpqa/zOK42jRLGj6Si29q4dCiWzSg4mpJ
        agh6jnX3ATyM4dITwS+yl74k8eyMBbJRSuQmjNkz59f7zy0WsDAbRon3UxIgMNSXQTIPlR
        +XIDXvb4p63KP5XM53tgVgWNchAkt8o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-FCxP7f2pM4GazxXbsPDlkw-1; Fri, 02 Apr 2021 05:35:39 -0400
X-MC-Unique: FCxP7f2pM4GazxXbsPDlkw-1
Received: by mail-wr1-f72.google.com with SMTP id p12so4114783wrn.18
        for <kvm-ppc@vger.kernel.org>; Fri, 02 Apr 2021 02:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pp7i/Rq4quxGmDckgflEr0uWdxRmtTCzqRhgMxNYmVI=;
        b=GNeVclAIn7DGU9Pf3687qo7t8CGz7wyObhrsaroAVlwjAo0sHuMUY9W2NRT1Ais5W9
         eXYgXBGJutiH7Xd1cIY60/KgIx+Ylxu3429RpaRp5jUvjCc4ziLK+42CLqesuKYTlF/4
         dNKXgnV2os+g1TWx85Q6qReGjnZBG+h+OuZJRwdZeKdIJo93bDllVEyb/itVlYoVW35V
         CcU7hWyW/G3qeqRyM/276Ck8nUeAq0+Whhm1w/EKmNiZ7bcevCvS8y3hLfUgtcWBOgh/
         Gie5AsHAs/Yu8TOuVLiCVW/cEiZdqupfFC5dX3bevZ60XTKJuqfznLqEKxiHoldlQrC4
         thUQ==
X-Gm-Message-State: AOAM530EWOQ2q2zTc2ZcZhkxugthHnH18pq9ytZ/WEDlSk/zLoytJUyY
        oG/NTUq3wY8Mg8Q3F9XMX6XyzuoPgN30gh5RwxS+v7SRgcEyM3zk5tSV1TnTS3PnJVG+r6Bvijf
        M0V2snVEsTH/eRYoU+w==
X-Received: by 2002:a05:6000:1a8a:: with SMTP id f10mr14051203wry.232.1617356138339;
        Fri, 02 Apr 2021 02:35:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3IM+fWBMIWWC0dXiX9SYqbGiBYCoQN4BHK3a4+s4pude6jmvmdlBwOmMacbQNHjcYC5pL4Q==
X-Received: by 2002:a05:6000:1a8a:: with SMTP id f10mr14051180wry.232.1617356138121;
        Fri, 02 Apr 2021 02:35:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id x6sm11605403wmj.32.2021.04.02.02.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 02:35:37 -0700 (PDT)
Subject: Re: [PATCH v2 07/10] KVM: Move MMU notifier's mmu_lock acquisition
 into common helper
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-8-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a30f556a-40b2-f703-f0ee-b985989ee4b7@redhat.com>
Date:   Fri, 2 Apr 2021 11:35:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 02/04/21 02:56, Sean Christopherson wrote:
> +		.handler	= (void *)kvm_null_fn,
> +		.on_lock	= kvm_dec_notifier_count,
> +		.flush_on_ret	= true,

Doesn't really matter since the handler is null, but I think it's 
cleaner to have false here.

Paolo

