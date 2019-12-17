Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AFF123915
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Dec 2019 23:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfLQWHZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Dec 2019 17:07:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58750 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726383AbfLQWHY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Dec 2019 17:07:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576620443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=slGVCNmnwx0F1K+nCa+cID8Tdy/RHxQkOhSUfY0VX6I=;
        b=CX0x0e6HVeTxGXIkedJwytxVeqMF8bXkTPMZfNXdt5IzzzUHj0e3SpRy0EF0yW8qlz5LZY
        lNDJk0Nkp4E5PoVlcdFdqgHHDQdN+LSbOV8K0lU+71sz1cfEOy2uvQI9C3f4qZ2foQBB31
        amuOGYhpkmqxwRjYrj5Vyx7A/ycpPbY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-UWaPhQcfNKipQ3zrdA6txA-1; Tue, 17 Dec 2019 17:07:21 -0500
X-MC-Unique: UWaPhQcfNKipQ3zrdA6txA-1
Received: by mail-qt1-f199.google.com with SMTP id p12so136740qtu.6
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Dec 2019 14:07:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=slGVCNmnwx0F1K+nCa+cID8Tdy/RHxQkOhSUfY0VX6I=;
        b=t3W5WF6KdEe3MS93yz76aHlwfoObUbhHi+ObN3yt7KkPqXzgMxCsKKzG5bj/irvCjX
         Zug1qqfjWJwbepIaoxC89vbcU0CKCxoLJS46QYAbacFdgrNHxNg1dWGrnPA/5uEHdMnf
         RvxcQYg9tcK9kWwH/2xu5pW6WVaThrKYxSHJjmBizGfecKWWAmgResKLa/oqRyssEeCY
         3Le0zjScddTtGH4LaKbnMzCW/J/IEFpw4VUuM73LLoJHrT1X1HUyFr9hm/u/YYV/XnaO
         fGJNzp6Z2ksWVwMEHf76BNdIVYwKGTLjNqdfVajftcj9zv1bGkUCZF69sSQSK0vM2QCO
         SFdA==
X-Gm-Message-State: APjAAAW2j5nQM+z+8awy9aI7I7wjqrwVAHqqJhEnBNLRhXHoKBl6tgqR
        XDaR4ixzbrQ/pO/e3913dpEqaINTEGLuNHJmHzH1I5KzORDEEp2bQvVMJynqeRZoysuqconYVlZ
        ElMo5b9zLRwpm59VIiw==
X-Received: by 2002:a0c:f68f:: with SMTP id p15mr6885121qvn.79.1576620441552;
        Tue, 17 Dec 2019 14:07:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYYchEVtwDwgk4Pr56pOeSJtWkuin1D2pVTuKZ433b4vaBfoHv6+mbPiSSnU54NveRu8NnwQ==
X-Received: by 2002:a0c:f68f:: with SMTP id p15mr6885088qvn.79.1576620441243;
        Tue, 17 Dec 2019 14:07:21 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id o9sm7592950qko.16.2019.12.17.14.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:07:20 -0800 (PST)
Date:   Tue, 17 Dec 2019 17:07:18 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 05/19] KVM: x86: Allocate memslot resources during
 prepare_memory_region()
Message-ID: <20191217220718.GJ7258@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191217204041.10815-6-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 17, 2019 at 12:40:27PM -0800, Sean Christopherson wrote:
> Allocate the various metadata structures associated with a new memslot
> during kvm_arch_prepare_memory_region(), which paves the way for
> removing kvm_arch_create_memslot() altogether.  Moving x86's memory
> allocation only changes the order of kernel memory allocations between
> x86 and common KVM code.
> 
> No functional change intended.

(I still think it's a functional change, though...)

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

