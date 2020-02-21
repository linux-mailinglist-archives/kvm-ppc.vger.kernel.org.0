Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D513168548
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Feb 2020 18:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgBURnl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 Feb 2020 12:43:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22598 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726408AbgBURnk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 Feb 2020 12:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582307019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DRklp/EGbzKFbnLcWYfCTJYwspK96XjQokoDYirC2jo=;
        b=Zq5loLRMhapr8Z6ukvadvkVrSgGgxRg5TF6t/38e/eFh+59MoFCMjjk48tjoRLAOxbIW1Q
        WG6cigCAPc0m6yp9g303rQXWg2OnjDD5cDEtdkMcouYkd7Yj/gHrUWQXfmv2a9P6bePCXs
        AL0aGnkBqvWhrgExa98bYL4qkmerXEk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-VexA8flfNjW5AKrPd1HGZw-1; Fri, 21 Feb 2020 12:43:38 -0500
X-MC-Unique: VexA8flfNjW5AKrPd1HGZw-1
Received: by mail-wr1-f69.google.com with SMTP id s13so1328031wru.7
        for <kvm-ppc@vger.kernel.org>; Fri, 21 Feb 2020 09:43:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRklp/EGbzKFbnLcWYfCTJYwspK96XjQokoDYirC2jo=;
        b=embWjyljZRaosEUFs/Qz5ANLmvIUtIl6xAQnKINvdRAmNTgXQAbIcAlziyBstLCHl3
         OmxyG/wcsY3sV8JVCIH/X7XK4JPFE7DC2uGVezjFgkFy9O3mh3C1z/XdogOZoRXUZBdZ
         Z5F/ztjh7GCjUuUVgu9o5yU36Dbj0tXMp4V4AmYNBDbc5Sl5wWY43kP0YDZO5uHTXhK2
         vPH07kxVOppTYGEl/9niZ9WGjGnRPeX+4ZFayXnYDePfed5w82/4da8H2WMm25UGFFMf
         lkxmMICZj4ZNU7gdTK4rdwHQobEbOb2nuIo7j+GI2opL8kG7jZ4BzzYASHwgVbjaT2be
         +EQw==
X-Gm-Message-State: APjAAAU2KAqUnh8k3qxhX4so8qMzcOLfK9F7Q6X5J/x/5nPj9kYJMUTw
        xjjKpyb0K1jfznX8DimojdTDKdYJ5Tulk0GBWvkS8xLddo3KMPbMAMuZpSrZLoCGYt0Gdni9IAp
        IqGuUbCYO9MKY10kJzg==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr51197007wrq.280.1582307017033;
        Fri, 21 Feb 2020 09:43:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2hj716qxeeRUnhWk7oLWJU5fIlTs2+zZOl+uuyj1LRQkzfullhSLke4OG8g9MBweopRblWg==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr51196974wrq.280.1582307016828;
        Fri, 21 Feb 2020 09:43:36 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id l131sm4908318wmf.31.2020.02.21.09.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:43:36 -0800 (PST)
Subject: Re: [PATCH v6 14/22] KVM: Clean up local variable usage in
 __kvm_set_memory_region()
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
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-15-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1467b8cd-3631-b5da-b285-dbdf31b75af7@redhat.com>
Date:   Fri, 21 Feb 2020 18:43:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218210736.16432-15-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 18/02/20 22:07, Sean Christopherson wrote:
> -sorted by update_memslots(), and the old
>  	 * memslot needs to be referenced after calling update_memslots(), e.g.
> -	 * to free its resources and for arch specific behavior.
> +	 * to free its resources and for arch specific behavior.  Kill @tmp
> +	 * after making a copy to deter potentially dangerous usage.
>  	 */
> -	old = *slot;
> +	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +	old = *tmp;
> +	tmp = NULL;
> +

Also: old = *id_to_memslot(...).

Paolo

