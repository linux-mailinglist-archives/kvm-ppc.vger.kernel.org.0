Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EC310B390
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Nov 2019 17:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfK0QjH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Nov 2019 11:39:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26005 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727111AbfK0QjG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Nov 2019 11:39:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574872745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5KhKOrpxrLqgwbANU9FPXd2v7BHYYitwNVa+lHWD/fM=;
        b=FL4rtCoN97CDCx0Dip9FhFFuuhE6uc3V1KITyKXNVgxyZpTggl+23cL+XJ5Ec7iMj+o9Pf
        WTvPiXAxcfUvrGrgv4wL48Afphci+bNOhV6DXhUrAISDap90BEFXw4ozKaBwgbafhIqi2i
        iwAwfA9vopwiR993mJsDR7w68ZrOM9M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-uwuTGnh9N-C6OWKgzcxFmg-1; Wed, 27 Nov 2019 11:39:03 -0500
X-MC-Unique: uwuTGnh9N-C6OWKgzcxFmg-1
Received: by mail-wr1-f70.google.com with SMTP id e3so12367894wrs.17
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Nov 2019 08:39:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=5KhKOrpxrLqgwbANU9FPXd2v7BHYYitwNVa+lHWD/fM=;
        b=acGgs3iO6yqnZeq/edbizdcTrTBxdtI+AoVeAR5FExACsvfS9N65ucdZt6oAGxoP1V
         c7OMsYuWgJ9z8IeiIWxCPEO82xAuUrdLzdHMmnNgSQk01+as2I+eq8gDtHRowk1NxxnU
         pSrF3h5WDWWEK2EsrnEAUg+ZVDh7xpXA/zIcvZbm2psVib3dBuzlUoGShmUd4zOnkCxY
         DxskzVDQAQuDcnzC+MZaFC+gbR9cbDDYymxu179eh8XeREiCiVIZ/f+kKqQqKg6DxeoC
         Y6irSyOCyOeZ6fyIWUglpViF+GLRfyDEInCHC3fZjjxMMfjrca5yO4rQCLRCa/2EDeRU
         icDg==
X-Gm-Message-State: APjAAAWSyrgxX5JtsET22uv4A6cPY9Pw4NEIkQmz/+UJLBQoIFlh4zT0
        grspFvHuPSG//cUFAHMKzGrwW5Xap4WnAp6Ezq4O9rZIYsm5Lshl4lNqWPcSeD0u6D4uBWth9bx
        kEZviXfzgDFLImjwcqQ==
X-Received: by 2002:a05:6000:cf:: with SMTP id q15mr3040007wrx.393.1574872742146;
        Wed, 27 Nov 2019 08:39:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyIStZSsrbnwYKwrWh48JWVFjGKUaVmqsGs/US9PW8bjWbuKu3HfljrAuBw9Rzgy+xh2mylw==
X-Received: by 2002:a05:6000:cf:: with SMTP id q15mr3039977wrx.393.1574872741822;
        Wed, 27 Nov 2019 08:39:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:459f:99a9:39f1:65ba? ([2001:b07:6468:f312:459f:99a9:39f1:65ba])
        by smtp.gmail.com with ESMTPSA id l10sm21494605wrg.90.2019.11.27.08.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 08:39:00 -0800 (PST)
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
To:     Leonardo Bras <leonardo@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
 <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
 <20191126171416.GA22233@linux.intel.com>
 <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
Date:   Wed, 27 Nov 2019 17:38:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3Lmtj4kXhlPoGtLw59Y3vMi7vMYbGdK96"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3Lmtj4kXhlPoGtLw59Y3vMi7vMYbGdK96
Content-Type: multipart/mixed; boundary="WkLoxHW9POPVer90XR7qa1FrtQmMJhTiI"

--WkLoxHW9POPVer90XR7qa1FrtQmMJhTiI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26/11/19 18:53, Leonardo Bras wrote:
>=20
> I agree an use-after-free more problem than a memory leak, but I think
> that there is a way to solve this without leaking the memory also.
>=20
> One option would be reordering the kvm_put_kvm(), like in this patch:
> https://lkml.org/lkml/2019/11/26/517

It's a tradeoff between "fix one bug" and "mitigate all bugs of that
class", both are good things to do.  Reordering the kvm_put_kvm() fixes
the bug.  kvm_put_kvm_no_destroy() makes all bugs of that kind less
severe, but it doesn't try to fix them.

Paolo


--WkLoxHW9POPVer90XR7qa1FrtQmMJhTiI--

--3Lmtj4kXhlPoGtLw59Y3vMi7vMYbGdK96
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl3epqQACgkQv/vSX3jH
roNLfwf9GmuvcuS13OxAQEUrvNcZKejSTVEMNHatSyAF9Od9GOJM9a9Uwk1vLAWd
My7k3ZReRw9q4jOHtQp8AmPjrD6DYIsc2vj/dhbqTqkdD/z5bPBo4fJQpfSJilil
8uU801MQwZQ5RjgIXw8tn5biazTH6fpgJzvqaMUCHLziNF+Cof7vkXj+PTxtnmD4
d0YUvgUYLpPvA3tuVL0u+o74kzmZ8a8E9p/50Bri/q2BwWHXfulPedtyD7EulR17
nxpE0iPmcuA7Dv5N9xlSRGl9s759Jpaivy9kSh4UWRMjRi98lLZY5cmSoYShLOa/
MOQNgu+/CvGw793PBYnLXxxOqva5Gg==
=+f4g
-----END PGP SIGNATURE-----

--3Lmtj4kXhlPoGtLw59Y3vMi7vMYbGdK96--

