Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB9A143F76
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jan 2020 15:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgAUO0e (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jan 2020 09:26:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51936 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727508AbgAUO0e (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jan 2020 09:26:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579616793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wB7oBUxPFMMo41Dhy/A6/q8IlRImdTJH/qsnmSwn8s8=;
        b=SkNEywdQxA2MNtBg974Sn0ZydviqoFf7LucDrjpzy39Tsk8ub9HgZig3tiUC1+XV8YjbVC
        dTZMVC1+cXJQ0Y9JvlxcvsQVNTw2JT79hjDojprlb9ehkrPWMN4i5j+ONb6/mm5FEXWbh0
        xgCF491KvV5JkAxjJhjWm2briBhiIR8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-jMgaKR43OkmbDw_cp---GA-1; Tue, 21 Jan 2020 09:26:31 -0500
X-MC-Unique: jMgaKR43OkmbDw_cp---GA-1
Received: by mail-wr1-f71.google.com with SMTP id c17so1376529wrp.10
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jan 2020 06:26:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wB7oBUxPFMMo41Dhy/A6/q8IlRImdTJH/qsnmSwn8s8=;
        b=l5DhMKqtVwKVeMPF3uFXvfmAPNYd8mPu53VTityp8Waye34ciJpLXH9nXY673hjp1A
         MWx8IAI4txYfCO+A/1a5x+/HlesYD6/CySgm0RsoLfOIa2KNvLTYgUWzuc8g7OCKM+Zc
         a+AXe8xDKVicOegP4y33MCDeA2gAWhQ8XQvQXUJEV4zO9nJ9g5dJKSwGHiVnXOV8IGIP
         pDAiMkyfwsIsMWztjHYtfohMO2U6mBTz42yscFlF44YqP+QhfoOydcY7RxZVUzlkvKig
         51xYngGdn9sVc38gBq+BlpBk1UiCSWHmtL7Z9njsasOgUzddOX87AA3uoOZqrq8jSomq
         Zs5Q==
X-Gm-Message-State: APjAAAX5jJ1fIfLpvul6BU0lFRVtygklX3qob01/epnWpBdxlcD0RjKl
        bxKtAziKO+ruVXy+KKI1QW61PSnYfGEV+JHfg1s6zE76TWGCngVEf/UCmIRyJ+E5iSDjrGCpsmL
        mIYTxGGrwtoNXMrJfPQ==
X-Received: by 2002:a5d:6089:: with SMTP id w9mr5614958wrt.228.1579616790218;
        Tue, 21 Jan 2020 06:26:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxWjz4Oe+H/gSHDnoSQ5o2pah30WIinDPbt454AQ/QK4v/OQZOFatnXxkc9zEh4soAyNb9f2w==
X-Received: by 2002:a5d:6089:: with SMTP id w9mr5614921wrt.228.1579616789896;
        Tue, 21 Jan 2020 06:26:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id q68sm4727432wme.14.2020.01.21.06.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:26:29 -0800 (PST)
Subject: Re: [PATCH 05/14] x86/mm: Introduce lookup_address_in_mm()
To:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
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
 <20200108202448.9669-6-sean.j.christopherson@intel.com>
 <871rs8batm.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <175cef39-1e0e-d1b7-69bc-95a3a2a651a7@redhat.com>
Date:   Tue, 21 Jan 2020 15:26:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <871rs8batm.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/01/20 22:04, Thomas Gleixner wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
>> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
>> index b5e49e6bac63..400ac8da75e8 100644
>> --- a/arch/x86/include/asm/pgtable_types.h
>> +++ b/arch/x86/include/asm/pgtable_types.h
>> @@ -561,6 +561,10 @@ static inline void update_page_count(int level, unsigned long pages) { }
>>  extern pte_t *lookup_address(unsigned long address, unsigned int *level);
>>  extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
>>  				    unsigned int *level);
>> +
>> +struct mm_struct;
>> +pte_t *lookup_address_in_mm(struct mm_struct *mm, unsigned long address,
>> +			    unsigned int *level);
> 
> Please keep the file consistent and use extern even if not required.
> 
> Other than that:
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 

Adjusted, thanks for the review.

Paolo

