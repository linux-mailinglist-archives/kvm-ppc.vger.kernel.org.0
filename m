Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2203508AB
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 23:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhCaVAo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 17:00:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhCaVA1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 17:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617224427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LQqUVLUZYdl8RcTGPBOfvhnoH130Hf3/RpFvvu9duY=;
        b=LygfMteufjDOoCwfEYkC2x8VvYk8LX3FbgkDA1/Bs0ggKwf0rqgabZabBpNHe91pELQ7In
        cqLsUGBosN3suqR7TPJ4wYLbbkD7/VUhgWoRAV6w+oUkpai1uxWYEgUPqh9Et4+ADO6sFc
        LpFSpHgXv4MBAMEdWAF8IsBmCWncAYA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-JUS-f7sdOpKCRB6UXjmC9Q-1; Wed, 31 Mar 2021 17:00:22 -0400
X-MC-Unique: JUS-f7sdOpKCRB6UXjmC9Q-1
Received: by mail-ej1-f72.google.com with SMTP id mj6so1360454ejb.11
        for <kvm-ppc@vger.kernel.org>; Wed, 31 Mar 2021 14:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2LQqUVLUZYdl8RcTGPBOfvhnoH130Hf3/RpFvvu9duY=;
        b=rS8QS61mQctU5JEtNbggNG0N3nCU4uix9Bioaty5xLK07tQiOTORJjPG5cxRayeyv3
         MaEfKK3XKzL9tawBmDhmmN/EDhq+M3Qd/OgNOopbN3qZ5fN2bU3iNeydKkOTaWxuWovs
         pNJimfHqrBwC7Q9CCGgGU4RdO6xf1BpNP3x202/rjr3gl/ODLQiD3zscKlLlKUJVjCa2
         cgGPgKS5paj9iHtbEcnY7Z9xEpohGFb3du/8RzL4XMBoA9aWFoz7MA0HCy91y478/eLw
         kFkVvpaqMbAje0AZDaU+JEVmtFCk8xYgxbl+0+dxrTDL1042Gp+YGarnadKa4lggppsY
         fYoQ==
X-Gm-Message-State: AOAM532OQ7czv5nx3FNldYbeg0luGFALlEGUPDgGkwTRRuNJhA2PF9ep
        VMNrCqqpBUdDmiosEY6l6qz/Qwl3UIkviDa8inhT56K9cZu7tVd0bAxKk4sR/FlUa5JF4RQO8+M
        gnFDahUs4U5NffyRswg==
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr6104412edr.374.1617224421716;
        Wed, 31 Mar 2021 14:00:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw50R87T4Vu7z/jVciLQACACQ+dsOT5/iwXfrDvSvIyaxglINHwXnv99OCNOBQhJmcFA6BI0w==
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr6104376edr.374.1617224421543;
        Wed, 31 Mar 2021 14:00:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm2291820eds.53.2021.03.31.14.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 14:00:20 -0700 (PDT)
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
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
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGTg/AWdieMM/mS7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60357fd0-d412-fe47-8023-8107a60ade7e@redhat.com>
Date:   Wed, 31 Mar 2021 23:00:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGTg/AWdieMM/mS7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 31/03/21 22:52, Sean Christopherson wrote:
> 100% agree with introducing on_lock separately from the conditional locking.
> 
> Not so sure about introducing conditional locking and then converting non-x86
> archs.  I'd prefer to keep the conditional locking after arch conversion.
> If something does go awry, it would be nice to be able to preciesly bisect to
> the conditional locking.  Ditto if it needs to be reverted because it breaks an
> arch.

Ok, that sounds good too.

Paolo

