Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9147DF190
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Oct 2019 17:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfJUPbB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Oct 2019 11:31:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfJUPbA (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 21 Oct 2019 11:31:00 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88707C08EC20
        for <kvm-ppc@vger.kernel.org>; Mon, 21 Oct 2019 15:31:00 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id a81so2534350wma.4
        for <kvm-ppc@vger.kernel.org>; Mon, 21 Oct 2019 08:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HXpSYYKAOP8qmSkuN9OQPmoeggjz/B9bVdloCHt7b9Q=;
        b=qx0Frfn+/OcAaaTOu4p2qKE8rxF8ROUuhI3ZC4pVAADmNMGuuyRBJicdmbyyFNFxo+
         oAxl/4Ddc0sWDbwt5XMgv5JFRqgoq3BkUqLLhuyGoWPejaZ4tLE4UfRHzIdBjox2kEPB
         7XpI5yBji86I5dT27Yx/2QBtdwmpCoogQWfdO69lR6LVjJfowY2urebEZNm1NQtVose7
         sLQRw1tApH7DyJPqfFGkVCQAXFoFrSVw7dWB8VIgZ8GiUNl9nh/Aiyvc/jfrAGEJBrkB
         ZLmMY7L2LiV2o3ZjL2U8l06jqj0z2gZVT/owZWXrHe6oSCXSJKjGCePOTyZ8rI11wG0x
         ovEQ==
X-Gm-Message-State: APjAAAUVdnloCVDhhlr0aovp2GJXTSB+D9VgSj4gfLza3pgSjUX9Wijf
        3KgRo0DPGBFpf3mjmV8ctVUbiVigFZ24gzuZ8XPCDxQMNEGyko6blbawTSl4QXB0TObckkLQScY
        Heusl54Yv3Pe09j9X/Q==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr19967243wmg.89.1571671859148;
        Mon, 21 Oct 2019 08:30:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTZ/lUVjW3sj3DfIBV7IL+Q0e6WVIFdjwvrO+qO4Vf7KPNSe2KjsRG/pv34P9t+UFKRzKAvw==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr19967224wmg.89.1571671858896;
        Mon, 21 Oct 2019 08:30:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id d8sm2174955wrr.71.2019.10.21.08.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:30:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Switch the order of the parameters in
 report() and report_xfail()
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Bill Wendling <morbo@google.com>, kvm-ppc@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Laurent Vivier <lvivier@redhat.com>
References: <20191017131552.30913-1-thuth@redhat.com>
 <20191017133031.wmc7y26nsd63zle6@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b6982589-33ff-db3f-d6f2-941a70cd0783@redhat.com>
Date:   Mon, 21 Oct 2019 17:30:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191017133031.wmc7y26nsd63zle6@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17/10/19 15:30, Andrew Jones wrote:
> Paolo, do you want me to do PULL
> requests for all the arm-related patches?

Yes, that's why it's not merged. :)

This patch is mostly automatically generated, so Thomas can send me v2
after your pull request is in, and I'll apply it.

Paolo
