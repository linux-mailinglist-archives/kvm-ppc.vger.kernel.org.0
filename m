Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A402A439853
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Oct 2021 16:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhJYOS6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Oct 2021 10:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229727AbhJYOS6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Oct 2021 10:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635171395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yBIeDqOkiGFurlFgD43y7wdSJN5RQI+Z9N38wXwm0c=;
        b=SUo34g/0kM1CYWnu/LExwYWV1SKFIlW8y+oySv51K1nK3/PPXv+QOi2Lbpq1HE6z3xXF7t
        zSHjExMDr5ZYlgOkDFONxkC/k8IVGLgl/arAl8biSmuA0uqFTWZZhuqheJda/oYoqHOMtZ
        cp5pxbm3hj6Sz0I0HUShmxhosa5rtuk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-3WIUgO4dOtOMgMK4D6e7IQ-1; Mon, 25 Oct 2021 10:16:34 -0400
X-MC-Unique: 3WIUgO4dOtOMgMK4D6e7IQ-1
Received: by mail-ed1-f72.google.com with SMTP id f21-20020a0564021e9500b003dd77985601so732881edf.9
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Oct 2021 07:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1yBIeDqOkiGFurlFgD43y7wdSJN5RQI+Z9N38wXwm0c=;
        b=59q/i38wp8tVOv4jIysgiQorO8oJQI7fTN4Vh9NR7GIxVa0sbHvUQf3JlPPQNAE7vO
         r21jOEM8ITPhxNeWRXkshp5V49H6xjCtWBj0B0VoJTZuKTx6U2dkdniDWqOQnjNdS7J/
         0ukZBfeTutni5+4CwFIposHCapxlCqtN700HX0vdn4ef3v42lne6+J4S0Dw0jXYqn6eQ
         dNTzYpYT81UCem6G+P/XELV6AmXBHiXeLgzg7/IRmutCStQpydB4Lno1z7PxaR9YpjBu
         QaZptMJ82GsoqsiSOzkcvNBBrjBEqHFam6s8RkLAOdXoewgQN54c4GkjVGm4QUGWr1UF
         Q+sg==
X-Gm-Message-State: AOAM532kntZfvL+cmHWurSaYqYqcJigS03TRBVJZE4Cie+/RLrMHNy7a
        y+qrnQTuTV+xUCBaZ+j3PI4hi8y2iY94doMPbufdJtNw2PqqrJKzigxL6d0srdXEF8gvo0R2pX4
        RscXrnlTzwkl3I03ijQ==
X-Received: by 2002:aa7:c384:: with SMTP id k4mr20307546edq.281.1635171393295;
        Mon, 25 Oct 2021 07:16:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy0DabLqT08o64mSEkgU1uBZtZezVv5apPrWyd4apSmXmCs+LkrkYQ/fnsjY0W8O5UT62zRA==
X-Received: by 2002:aa7:c384:: with SMTP id k4mr20307513edq.281.1635171393133;
        Mon, 25 Oct 2021 07:16:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bx2sm3600770edb.44.2021.10.25.07.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:16:32 -0700 (PDT)
Message-ID: <01b5edae-aaa9-e96d-daaa-197c0c3a0431@redhat.com>
Date:   Mon, 25 Oct 2021 16:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 43/43] KVM: VMX: Don't do full kick when handling
 posted interrupt wakeup
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-44-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-44-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/10/21 04:12, Sean Christopherson wrote:
> When waking vCPUs in the posted interrupt wakeup handling, do exactly
> that and no more.  There is no need to kick the vCPU as the wakeup
> handler just need to get the vCPU task running, and if it's in the guest
> then it's definitely running.

And more important, the transition from blocking to running will have 
gone through sync_pir_to_irr, thus checking ON and manually moving the 
vector from PIR to RVI.

Paolo

