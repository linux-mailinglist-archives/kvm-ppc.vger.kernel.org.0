Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B701FC57
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 May 2019 23:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfEOVlA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 15 May 2019 17:41:00 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:41295 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfEOVlA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 15 May 2019 17:41:00 -0400
Received: by mail-wr1-f54.google.com with SMTP id g12so783712wro.8
        for <kvm-ppc@vger.kernel.org>; Wed, 15 May 2019 14:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3l2b5U5MnUONYDesPrYGDUO70H7doCCRIcVWaH0dmA=;
        b=cyCA7JBiUBf+zbcSvIes0KPCDjmqnQRRuYxqoL8sRAmVPjyb4nuUotvyP98L++jQSy
         R3QTuDD6smpNpZzyOj0YjtVHEuHInVe2X1hpVZfwWDy6ahhLrEXrdDzjZcLBwB07jd3E
         ML3CrCH6rM5m+fNf5hFCJAUORQpbNkvvns2xdzONcx2x9qUEwhgoseJ0QFcanYKgZKuV
         1BDtCYD7h79z1FTWx90yn3N7zbhxhGQpq0281gmNiLF4iwbt9XHfFVy04r2m7qq3BCc4
         u/hBno05/XDwBrFcd0+Qh+ANyE7lesVqFUZ8YoLvjIz4RquhNEhqciiN44zS1MbZFS+e
         8ovg==
X-Gm-Message-State: APjAAAVpY5gMNiZY9ltvH/jTlxqURk3B+kS4R9P1lkhb8gh2wC9D1rOk
        pPVILfTLUbblur9sTpFU0DKMhObO0Qc=
X-Google-Smtp-Source: APXvYqx5tmNLoLZ/z4emlsVi8ax44v2hTqGrnnTGREvFz9J4SA09qTosM85jMDvkNuhSpc656akCbQ==
X-Received: by 2002:adf:dc08:: with SMTP id t8mr26132781wri.220.1557956458518;
        Wed, 15 May 2019 14:40:58 -0700 (PDT)
Received: from [172.10.18.228] (24-113-124-115.wavecable.com. [24.113.124.115])
        by smtp.gmail.com with ESMTPSA id o6sm5110319wrh.55.2019.05.15.14.40.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 14:40:57 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.2-2 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20190514101327.GA13522@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bcb4ef86-1bca-4f6a-2e31-eede09192672@redhat.com>
Date:   Wed, 15 May 2019 23:40:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514101327.GA13522@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 14/05/19 12:13, Paul Mackerras wrote:
> Paolo, Radim,
> 
> I have added 3 more commits to my kvm-ppc-next tree, for various fixes
> that have come in recently.  There is one bug fix, one spelling fix,
> and one commit that removes some code that does nothing.  The net
> result is 12 fewer lines of code in the kernel. :)
> 
> If you pull this tag and not the earlier kvm-ppc-next-5.2-1 tag, you
> might want to include the text from that tag in the commit message.
> That text is:
> 
> "
> PPC KVM update for 5.2
> 
> * Support for guests to access the new POWER9 XIVE interrupt controller
>   hardware directly, reducing interrupt latency and overhead for guests.
> 
> * In-kernel implementation of the H_PAGE_INIT hypercall.
> 
> * Reduce memory usage of sparsely-populated IOMMU tables.
> 
> * Several bug fixes.

Pulled, thanks.  Sorry for not following up on this before, my
travelling schedule was horrible for this merge window.

Paolo
