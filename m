Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BFCE07F2
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Oct 2019 17:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388733AbfJVPxb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Oct 2019 11:53:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388383AbfJVPxa (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 22 Oct 2019 11:53:30 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A2144E92A
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Oct 2019 15:53:30 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id s9so9343820wrw.23
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Oct 2019 08:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JG+rDaiZPjv/G30aIXSiabMNCIhXTu4D3139P64uM1U=;
        b=p/saoEXcS27XGDKLJDaw5NnnWA85CP+FIswQzSwkEL2MPMtn1U9uAHBrKvJlqMznvC
         D5Qe/DFKMYy4XsGzQGHbI1PPlhSr4iJG+E/58UCI3lJDvpsdzQWfMizT6A76O9hcfFgz
         fM22qHaItaHwlQ/5sDCiTQHGvuU+9MjOMq6RZFaOYYr7+6det7wsHNtq6hY5j6+VBjxL
         MtUHcb7YMOne5v/aLPWJaVHiik1l3AUH1j6J0DkhtvsbC1Ym+hSJhMhltezHLMOjP/94
         lOOWGOE816TF+8hGvsi3baiRQbBODAZ1+2gZSkgmvDLcHkWIv2d0iOZOUyvwUXiwBzKE
         MjTQ==
X-Gm-Message-State: APjAAAU39H3G9bdeDjJ3NrfH36+wdLnrfxjedLiUvnOrO9S8eFQnZ76Q
        h8qWREYO1MG4+j9evC2JaAvv776EohaynOnjTmDK0FKREguaneT/WOdsxJc0duzKebxLGDuTKL/
        sBHXGMl51uigoSROEBw==
X-Received: by 2002:a1c:c90c:: with SMTP id f12mr3515209wmb.97.1571759608918;
        Tue, 22 Oct 2019 08:53:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz6V+VvQ3ZIcj/uWsxd5zvt1LhKvigbB1GL0YOeGKZ2oispvsSJTapzUQJ7s70S4Bt0HGQCSQ==
X-Received: by 2002:a1c:c90c:: with SMTP id f12mr3515188wmb.97.1571759608659;
        Tue, 22 Oct 2019 08:53:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id t123sm24286579wma.40.2019.10.22.08.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 08:53:28 -0700 (PDT)
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
 <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
 <20191022155220.GD2343@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5c61c094-ee32-4dcf-b3ae-092eba0159c5@redhat.com>
Date:   Tue, 22 Oct 2019 17:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022155220.GD2343@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 22/10/19 17:52, Sean Christopherson wrote:
> 
> Anyways, I'm not at all opposed to adding comments, just want to make sure
> I'm not forgetting something.  If it's ok with you, I'll comment the code
> and/or functions and reply here to refine them without having to respin
> the whole series.

Yes, I agree this is better.

Paolo
