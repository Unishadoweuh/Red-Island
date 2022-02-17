function rgba(hex,opacity){
    hex = hex.replace('#','');
    redColor = parseInt(hex.substring(0,2), 16);
    greenColor = parseInt(hex.substring(2,4), 16);
    blueColor = parseInt(hex.substring(4,6), 16);

    result = 'rgba('+redColor+','+greenColor+','+blueColor+','+opacity/100+')';
    return result;
}

let loadJS = function(url, implementationCode, location) {
	let scriptTag = document.createElement('script');
	scriptTag.src = url;

	scriptTag.onload = implementationCode;
	scriptTag.onreadystatechange = implementationCode;

	location.appendChild(scriptTag);
};

Object.prototype.addMultiListener = function(eventNames, listener) {
	let events = eventNames.split(' ');

	if (NodeList.prototype.isPrototypeOf(this) == true) {
		for (let x=0, xLen=this.length; x<xLen; x++) {
			for (let i=0, iLen=events.length; i<iLen; i++) { this[x].addEventListener(events[i], listener, false); }
		}
	}

	else if (HTMLElement.prototype.isPrototypeOf(this) == true) {
		for (let i=0, iLen=events.length; i<iLen; i++) { this.addEventListener(events[i], listener, false); }
	}
}


window.onload = function () {
	let eventCallback = {
		ui: function(data) {
			let config = data.config;

			if (config.showWalletMoney == true) { document.querySelector('#wallet').style.display = 'block'; }
			if (config.showBankMoney == true) { document.querySelector('#bank').style.display = 'block'; }
			if (config.showBlackMoney == true) { document.querySelector('#blackMoney').style.display = 'block'; }
			if (config.showSocietyMoney == true) { document.querySelector('#society').style.display = 'block'; }
			if (config.showJob == true) { document.querySelector('#job').style.display = 'block'; }
		},
		element: function(data) {
			if (data.task == 'enable') { document.querySelector('#'+data.value).style.display = 'block'; }
			else if (data.task == 'disable') { document.querySelector('#'+data.value).style.display = 'none'; }
		},
		setText: function(data) {
			let key = document.querySelector('#'+data.id+' span');
			let html = data.value;
			saferInnerHTML(key, html);
		},
		setFont: function(data) {
			document.querySelector('#font').href = data.url;
			document.body.style.fontFamily = data.name;
		},
		
		setMoney: function(data) {
			data.value = data.value.toLocaleString();
			let oldValue = document.querySelector('#'+data.id+' span').innerHTML;
			if (oldValue != data.value) { document.querySelector('#'+data.id).classList.add('pulse'); }
			eventCallback['setText'](data);
		},
		
	};

	document.querySelectorAll('.icon i').addMultiListener('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function () { this.parentElement.classList.remove('pulse'); this.parentElement.classList.remove('shooting'); });

	document.querySelectorAll('.info.vehicle').addMultiListener('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function () {
		this.classList.remove('fadeOut', 'fadeIn');
	});

	window.addEventListener('message', function(event) {
		eventCallback[event.data.action](event.data);
	});
}