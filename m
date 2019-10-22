Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37915E05D6
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Oct 2019 16:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbfJVOEW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Oct 2019 10:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387547AbfJVOEW (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 22 Oct 2019 10:04:22 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A17685546
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Oct 2019 14:04:21 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id s17so3570057wrp.17
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Oct 2019 07:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cI7ihz+0OXiuq2sxX+N5cJBmKtQum9zSe4e7C6PdS6E=;
        b=IAcM1CzKw3b+hJN3qeRb0fVKV5hmULOWw3xGrmkyunH8K//kwJMNDYt5AoKlPxJCf/
         VwPWI53xn1r++QpHTRHzoUGhkeuhWN/rY20hh8uAchMBqQouhFcAbctlqEfF7AL/Re5V
         IRl2XpB7dg8iC1h6+qovNIBSkKZ1TDxvrIjviIIQ0AJ7GxSJLj76fvP3ILNlFbFwTFMe
         td/QNccKHlWgoW2t2OgDZakpHXoOmSjPTaijIK4p3Up4jjuWNSdWPbrxuaEwWf0IfaIE
         BqVybKKJEvUNsC2JLk1BgEN3f47tx57ufLxBaO8ElH9cD0dbx1lMjbr0bOZ4VLyIQ12b
         9Qfw==
X-Gm-Message-State: APjAAAVCNh3JtsSnE+6d7pfgXxvAPoTtvu5bGSaHzsZ9k8iUsljVgWd0
        Y8d0E6GBvqZHEss9dA2LhutEsLYrVb7aDkPfpqrxYK22Racgbe3EYgpyDBm4JLtYBgwZ/MUk4dO
        rSKHe1w0EdW+VjkZiDg==
X-Received: by 2002:a1c:4c02:: with SMTP id z2mr1302150wmf.78.1571753060058;
        Tue, 22 Oct 2019 07:04:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzBB+WAq2KC5VOJdeNtgubd6CTAxDm0c28bIfc4NXYNFYsicJIJc7CEyPBTiO7yZbxm83G9Ow==
X-Received: by 2002:a1c:4c02:: with SMTP id z2mr1302127wmf.78.1571753059747;
        Tue, 22 Oct 2019 07:04:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id p17sm14939972wrn.4.2019.10.22.07.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 07:04:19 -0700 (PDT)
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
Date:   Tue, 22 Oct 2019 16:04:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022003537.13013-15-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 22/10/19 02:35, Sean Christopherson wrote:
> +static inline int kvm_shift_memslots_forward(struct kvm_memslots *slots,
> +					     struct kvm_memory_slot *new)
> +{
> +	struct kvm_memory_slot *mslots = slots->memslots;
> +	int i;
> +
> +	if (WARN_ON_ONCE(slots->id_to_index[new->id] == -1) ||
> +	    WARN_ON_ONCE(!slots->used_slots))
> +		return -1;
> +
> +	for (i = slots->id_to_index[new->id]; i < slots->used_slots - 1; i++) {
> +		if (new->base_gfn > mslots[i + 1].base_gfn)
> +			break;
> +
> +		WARN_ON_ONCE(new->base_gfn == mslots[i + 1].base_gfn);
> +
> +		/* Shift the next memslot forward one and update its index. */
> +		mslots[i] = mslots[i + 1];
> +		slots->id_to_index[mslots[i].id] = i;
> +	}
> +	return i;
> +}
> +
> +static inline int kvm_shift_memslots_back(struct kvm_memslots *slots,
> +					  struct kvm_memory_slot *new,
> +					  int start)

This new implementation of the insertion sort loses the comments that
were there in the old one.  Please keep them as function comments.

Paolo
