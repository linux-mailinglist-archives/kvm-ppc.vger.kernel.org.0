Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE861E79BC
	for <lists+kvm-ppc@lfdr.de>; Fri, 29 May 2020 11:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgE2JsV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 29 May 2020 05:48:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28009 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbgE2JsU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 29 May 2020 05:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590745698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6w/D95eveaUv1V0PC/H4Q2Slese/OFGRios5LqI3Lo=;
        b=NNRa75Reo0T7n96yVI7Ok3mL2czI6H/WaO65i3c7Hs/IqF4hu+vcux7YQq8i2UZeTrqPSN
        pE4AEGRULLd1W7LzhH5NR4Wy7/dY8dqCokBLFNTIzIaDPEakwm21vZX2gtb98FZx4MobdT
        SC8vWa6WPCTVpXrVLL0jnNssyOr3UyM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-_pXPTDEWPBy3KTHR8CSOeg-1; Fri, 29 May 2020 05:48:17 -0400
X-MC-Unique: _pXPTDEWPBy3KTHR8CSOeg-1
Received: by mail-wr1-f72.google.com with SMTP id s17so821521wrt.7
        for <kvm-ppc@vger.kernel.org>; Fri, 29 May 2020 02:48:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f6w/D95eveaUv1V0PC/H4Q2Slese/OFGRios5LqI3Lo=;
        b=lppUvZ5mBfgZsa12bmCfr0V6WGL+nhJfqd27oCJ9K4vy0rnKgHzp2oW1+qFca5N0T/
         nx2N2GEUBabu40aYmBArBOJg5M6SKR1SMIdMDhauzIEHF9n3zUGpfMHkcSfeM0LxcTBv
         Ux19DMkuiCXei/LxRhp2W70UJ5IQhaGWrspfRazqbQpArS3USWZ/Y6ciRd9sblJwO3X7
         WA9QdJ1V++jomFTFuOvzk1dzbfSYlbfMQ3LydNYaJH7kdOLJZr5eaTmrRiHZYm9dr4f0
         RzJeB5dKLv0DIuC3f9HhXB6DmwIdFd7eVUkqFl0piJfFoHPUI0k2fghtW/gtc3LMYZdx
         QCqw==
X-Gm-Message-State: AOAM530fcX6e1/7n2IuLsThNCij+bUpvuvTjVshhIL7yw5O1ybNzOwFm
        V3tECN6zdJl4dHYuDAi+rJ9I+PXYbidF9Lc4uIE7KbVFNd0c9rnkJKrCYGyqPOpq4Hnq5w4VJlX
        L88M/u/wntgeCv9hpuQ==
X-Received: by 2002:a05:6000:124e:: with SMTP id j14mr7990044wrx.154.1590745695770;
        Fri, 29 May 2020 02:48:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwY5u800IehczM/cQdM/5qPUlY08WZ5sRKP7f3fL0jBY9tgOmWNoklBLDcXU/RONPfyNhc2eg==
X-Received: by 2002:a05:6000:124e:: with SMTP id j14mr7990004wrx.154.1590745695574;
        Fri, 29 May 2020 02:48:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id k26sm10567358wmi.27.2020.05.29.02.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:48:15 -0700 (PDT)
Subject: Re: [PATCH v4 6/7] KVM: MIPS: clean up redundant 'kvm_run' parameters
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Huacai Chen <chenhuacai@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>, paulus@ozlabs.org,
        mpe@ellerman.id.au,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org, hpa@zytor.com,
        Marc Zyngier <maz@kernel.org>, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, Peter Xu <peterx@redhat.com>,
        thuth@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-7-tianjia.zhang@linux.alibaba.com>
 <CAAhV-H7kpKUfQoWid6GSNL5+4hTTroGyL83EaW6yZwS2+Ti9kA@mail.gmail.com>
 <37246a25-c4dc-7757-3f5c-d46870a4f186@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30c2ac06-1a7e-2f85-fbe1-e9dc25bf2ae2@redhat.com>
Date:   Fri, 29 May 2020 11:48:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <37246a25-c4dc-7757-3f5c-d46870a4f186@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 27/05/20 08:24, Tianjia Zhang wrote:
>>>
>>>
> 
> Hi Huacai,
> 
> These two patches(6/7 and 7/7) should be merged into the tree of the
> mips architecture separately. At present, there seems to be no good way
> to merge the whole architecture patchs.
> 
> For this series of patches, some architectures have been merged, some
> need to update the patch.

Hi Tianjia, I will take care of this during the merge window.

Thanks,

Paolo

