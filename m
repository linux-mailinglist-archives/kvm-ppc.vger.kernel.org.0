Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413C1143FC8
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jan 2020 15:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgAUOku (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jan 2020 09:40:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729096AbgAUOku (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jan 2020 09:40:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579617648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSSit0Wm+RQr1Jgst7x5naV4XKUyLXD3AhAyDv7TiYs=;
        b=Tj7tj63hMPU19wrJcoj1TH8CGkiDyBpUV3lfXKpgy2kY8apxYkEalVoHqja4B886ckbsla
        +UrtKNn3GJ1fSQym3X5fbjorDKM6/GCXAXtUvWlvrlsa02kmH+/vbw1UsKo+MhYL9VMKoa
        qtADOhqfqaNDHHfMIPqDxYy9/nL2ugM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-gHzxcIYFMrKouUmPyN1xYg-1; Tue, 21 Jan 2020 09:40:47 -0500
X-MC-Unique: gHzxcIYFMrKouUmPyN1xYg-1
Received: by mail-wr1-f72.google.com with SMTP id t3so1375571wrm.23
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jan 2020 06:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JSSit0Wm+RQr1Jgst7x5naV4XKUyLXD3AhAyDv7TiYs=;
        b=kJNNJbxAEWSZzPXe2s0aTeIgsVtNCK0S8+aOt8WVFRcxhh13u6DtQk3mwX1RUSDqU5
         FLLZci1YLvsXEf9857XZJk57KyyLSvy54Sr3PLs5r3wqVrsFony9DmpLpH9UROlaRNui
         e/B71Pgz3SOJ94lgCuQMVnalxf6Q7uyccoCje4m6ny/PrWfB13Gs8K1eCKpLfMn7fSYH
         7tGOkNXtdJwqZI4qu6GyEUGNxcrRo3sAudLvC55GSkj8hVHVEsYTHiFXrzv/qkVZTiXb
         6dnV7I27Mb7xHUSIJQa7GPLISm6RDhdhcKbTV3n7yLe0pU6dtWnjX52fhGSEXJW/TMNo
         QzJA==
X-Gm-Message-State: APjAAAX04m6X6l3373/sbYptzCo9k+EOLKIvMDzowseMZKPX9uA+aY46
        EOOIsO5r0ZmtBUpRAzj8bKUkAhWJ4/ZCg5xsgrgISXUV98OwgNlNRfp4RNQNekHw6yTPoxAVkZQ
        3/hUXxM8tQHQfbv3tEA==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr4596900wml.71.1579617645323;
        Tue, 21 Jan 2020 06:40:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUkg5d8MSonCO4Ge0L397jZ+4TsON4lVJzpAggAw2WjkJCWhAHkQt1Jw0IPvgT93BvWQD3aw==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr4596848wml.71.1579617645022;
        Tue, 21 Jan 2020 06:40:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id b67sm4417502wmc.38.2020.01.21.06.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:40:44 -0800 (PST)
Subject: Re: [PATCH 07/14] KVM: x86/mmu: Walk host page tables to find THP
 mappings
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-8-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e9987a2-c34f-362d-a123-7dc4849811d1@redhat.com>
Date:   Tue, 21 Jan 2020 15:40:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-8-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 08/01/20 21:24, Sean Christopherson wrote:
> +
> +	/*
> +	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
> +	 * "writable" check in __gfn_to_hva_many(), which will always fail on
> +	 * read-only memslots due to gfn_to_hva() assuming writes.  Earlier
> +	 * page fault steps have already verified the guest isn't writing a
> +	 * read-only memslot.
> +	 */
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!memslot_valid_for_gpte(slot, true))
> +		return PT_PAGE_TABLE_LEVEL;
> +
> +	hva = __gfn_to_hva_memslot(slot, gfn);
> +

Using gfn_to_memslot_dirty_bitmap is also a good excuse to avoid
kvm_vcpu_gfn_to_hva.

+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
+	if (!slot)
+		return PT_PAGE_TABLE_LEVEL;
+
+	hva = __gfn_to_hva_memslot(slot, gfn);

(I am planning to remove gfn_to_hva_memslot so that __gfn_to_hva_memslot
can lose the annoying underscores).

Paolo

