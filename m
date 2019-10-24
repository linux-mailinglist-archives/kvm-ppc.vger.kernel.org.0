Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC763E3D1F
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Oct 2019 22:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfJXUYO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Oct 2019 16:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfJXUYN (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 24 Oct 2019 16:24:13 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30BDE85543
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Oct 2019 20:24:13 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id x9so7091636wrq.5
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Oct 2019 13:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZRT3dVDu4csQhfGia5nCcLIZe2YAZImGVAl5gr6pUcE=;
        b=pY5nKgbdvJVraT4aeBngYr7MWD4/Jgu6fFl8948GU5qxD5wGb6ArW0zNksU/srMWtt
         SFTvn5CxZJkkCeWaC6vrFn6D8ZncoaQNNIGBmbJV1KCqAPy9HLYAEN6rZ3l0lOXzA6Ax
         pAFLGroKZUmKiZ3sBf7WFSvlx2Q4smKz8Rbo135uwxEmNfnlVKjrbK3EFSOPRlLkkKXX
         RmmfBTTcTABt+1CFxQKQqdUaAgcekOBxIFb1Vgxq97KIy9Bcb+otFTsDQ42rb/VHjalN
         wMO15bSDpgs8zMKG86w15j/yHVb2Rm/7RlxBEzL3D89XMvVMXyA2QMmpcd2kIV18OZIn
         BFAQ==
X-Gm-Message-State: APjAAAX2Kmm23bhTckIPxw8L0d+BpDcumPxlpxdIaE01Ov5V5MWO7Hue
        GbJQYLj8CCaiJ3H38Rv0FDBpbyHaL3+neZDYKhxYQ/MURFSFiGao0cIbSobvIYuXgFA9sOz1kZB
        PCHBWZGyStF8ZraMGpA==
X-Received: by 2002:a5d:4a03:: with SMTP id m3mr5578390wrq.359.1571948651616;
        Thu, 24 Oct 2019 13:24:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4p9hq+y70/y8WlLn0/OTguCJ96CcuhVxxvxeJyvnyp8Rzk3Jc6wiDxI+nnKN+OJXQKdf4DA==
X-Received: by 2002:a5d:4a03:: with SMTP id m3mr5578369wrq.359.1571948651305;
        Thu, 24 Oct 2019 13:24:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:302c:998e:a769:c583? ([2001:b07:6468:f312:302c:998e:a769:c583])
        by smtp.gmail.com with ESMTPSA id v128sm5252067wmb.14.2019.10.24.13.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 13:24:10 -0700 (PDT)
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
 <5c61c094-ee32-4dcf-b3ae-092eba0159c5@redhat.com>
 <20191024193856.GA28043@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5320341c-1abb-610b-8f5e-090a6726a9b1@redhat.com>
Date:   Thu, 24 Oct 2019 22:24:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024193856.GA28043@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 24/10/19 21:38, Sean Christopherson wrote:
> only
>  * its new index into the array is update.

s/update/tracked/?

  Returns the changed memslot's
>  * current index into the memslots array.
>  */
> static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
> 					    struct kvm_memory_slot *memslot)
> {
> 	struct kvm_memory_slot *mslots = slots->memslots;
> 	int i;
> 
> 	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> 	    WARN_ON_ONCE(!slots->used_slots))
> 		return -1;
> 
> 	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> 		if (memslot->base_gfn > mslots[i + 1].base_gfn)
> 			break;
> 
> 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
> 
> 		/* Shift the next memslot forward one and update its index. */
> 		mslots[i] = mslots[i + 1];
> 		slots->id_to_index[mslots[i].id] = i;
> 	}
> 	return i;
> }
> 
> /*
>  * Move a changed memslot forwards in the array by shifting existing slots with
>  * a lower GFN toward the back of the array.  Note, the changed memslot itself
>  * is not preserved in the array, i.e. not swapped at this time, only its new
>  * index into the array is updated

Same here?

>  * Note, slots are sorted from highest->lowest instead of lowest->highest for
>  * historical reasons.

Not just that, the largest slot (with all RAM above 4GB) is also often
at the highest address at least on x86.  But we could sort them by size
now, so I agree to call these historical reasons.

The code itself is fine, thanks for the work on documenting it.

Paolo

